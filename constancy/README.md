# constancy

Dockerized version of [constancy][constancy] with an extra utility script
for watching a directory tree and re-running constancy against it.

## Environment variables

See the [upstream variables][constancy-env]. 

## Scripts

### `constancyd`

This is the utility script for watching changes. See the documentation for
the volume `/etc/constancy.d` for more information.

The script accepts no arguments and exits with `0` in case `/etc/constancy.d`
contains no `constancy.yml` files.

## Volumes

### `/etc/constancy.d`

Contents of this directory will be watched for changes, and any `constancy.yml`
found inside will be re-run upon an event.

    docker run --rm -it \
      -v "${PWD}/constancy":/etc/constancy.d:ro \
      amireh/constancy:0.1.5 \
        constancyd

## History

### 0.3.1-1

Added patch for constancy to accept --yes flag in push/pull commands
for a better non-interactive experience.

[constancy]: https://github.com/daveadams/constancy
[constancy-env]: https://github.com/daveadams/constancy#environment-configuration
