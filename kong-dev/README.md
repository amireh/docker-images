# kong-dev

An image that contains development tools for testing Kong plugins.

## Usage

`busted-kong` is the primary script for testing plugin code. It forwards to
`busted` so it has the interface which you can query by running:

    docker run amireh/kong-dev:0.11.2 busted-kong --help

To run it against your source code, mount the folder that contains your
plugins* to `/usr/local/rocks` and run `busted-kong`:

```shell
docker run \
  -v "$PWD":/usr/local/rocks \
  amireh/kong-dev:0.11.2 \
    busted-kong /usr/local/rocks
```

- runs kong migrations (unless `$KONG_DEV_MIGRATE` is set to 0)
- runs the [busted][1] test runner inside Kong's (openresty) environment
- instruments code for coverage reporting using [luacov][2] and outputs
  an HTML report using [pycobertura][3]

### File structure

In order for `luarocks` to find your custom plugins (and in turn, Kong),
it is configured to look under the directory specified in
`$KONG_DEV_ROCKS_DIR` which by default is set to `/usr/local/rocks`.

For this to work, it is expected that each of your plugin's source
code lives in its own folder under a parent one, a hierarchy similar
to the following:

```
my-app
  |- rocks
    |- kong
      |- plugins
        |- a
          |- kong-plugin-a-1.0-0.rockspec
          |- handler.lua
          |- spec/...
        |- b
          |- kong-plugin-b-1.0-0.rockspec
          |- lib
            |- __tests__
              |- handler.test.lua
            |- handler.lua
```

Then you would mount `my-app/rocks` to `/usr/local/rocks`. Requiring
the handler of plugin `a` in Lua would then be doable as:

```lua
require 'kong.plugins.a.handler'
```

Which is exactly what Kong expects and does.

[1]: https://olivinelabs.com/busted/
[2]: https://github.com/keplerproject/luacov
[3]: https://pypi.org/project/pycobertura/

## Configuration

The following environment variables can be used to configure the
scripts inside the container:

Name                      | Default | Description
------------------------- | ------- | -----------
`KONG_DEV_MIGRATE`        | 1 | run `kong migrations up` before running busted
`KONG_DEV_LUACOV_OUTDIR`  | /usr/local/coverage | where to store cov reports
`KONG_DEV_LUACOV_CONFIG`  | /etc/luacov.conf.lua | mount a file at this path to customize luacov
`KONG_DEV_BUSTED_CONFIG`  | /etc/busted.conf.lua | mount a file at this path to customize busted
`KONG_DEV_ROCKS_DIR`      | /usr/local/rocks | container path to the source code to test


## Upgrading to a newer Kong version

Copy the "helpers file"[1] from the upstream repo into:

    container/share/kong-$KONG_VERSION/kong/spec_helpers.lua

Edit that file such that the following statements are present:

```lua
local BIN_PATH = "kong"
local TEST_CONF_PATH = "/etc/kong/kong.conf"
local CUSTOM_PLUGIN_PATH = ""
```

Copy the `init.lua` file from the upstream repo into some
temporary file (call it `tmp/init.lua`) and insert the
luacov patch snippet[2] into it at the spot right before the
plugins are loaded. Save the modified version in a different
file so that we can generate a diff.

This may vary slightly between versions and that's why we can't
use the same patch.

Generate the patch:

    diff -u \
        tmp/init.lua \
        tmp/init-with-cov.lua >
        container/patches/kong-$KONG_VERSION/kong.init.lua.patch

Delete those two source files.

Build the image:

    docker build . \
      --build-arg KONG_VERSION=$KONG_VERSION \
      -t amireh/kong-dev:$KONG_VERSION

Run the tests:

    ./scripts/ci.sh -e version=$KONG_VERSION

[1]: https://raw.githubusercontent.com/Kong/kong/0.12.3/spec/helpers.lua

## TODO

[x] automatic pickup of user rocks
[x] busted-kong binary
[x] luacov
