FROM kong:0.11.2-alpine

ENV KONG_DEV_MIGRATE="1" \
    KONG_DEV_LUACOV_OUTDIR="/usr/local/coverage" \
    KONG_DEV_LUACOV_CONFIG="/etc/luacov.conf.lua" \
    KONG_DEV_BUSTED_CONFIG="/etc/busted.conf.lua" \
    KONG_DEV_ROCKS_DIR="/usr/local/rocks"

RUN apk add --no-cache \
  build-base \
  git \
  curl \
  libxml2-dev \
  libxslt-dev \
  openssl-dev \
  postgresql \
  postgresql-client \
  py-pip \
  python \
  python-dev \
  shadow \
  yaml-dev \
  zip

RUN pip install --upgrade pip && \
    pip install pycobertura==0.10.4

RUN luarocks install busted 2.0.rc12-1 && \
    luarocks install luacheck 0.22.1-1 && \
    luarocks install luacov 0.13.0-1 && \
    luarocks install luacov-cobertura 0.2-1

VOLUME [ "/usr/local/coverage" ]

COPY container /tmp/kong-dev

RUN \
    # install config files
    cp -r /tmp/kong-dev/etc/* /etc/ && \
    # install scripts
    cp /tmp/kong-dev/bin/* /usr/local/bin/ && \
    # replace "busted" with busted-kong and keep a ref in "busted-lua"
    mv /usr/local/bin/busted /usr/local/bin/busted-lua && \
    ln -s /usr/local/bin/busted-kong /usr/local/bin/busted && \
    # shortcut to resty's lua for debugging
    ln -s /usr/local/openresty/bin/resty /usr/local/bin/lua-resty && \
    # patch kong source code
    patch \
      /usr/local/share/lua/5.1/kong/init.lua < \
      /tmp/kong-dev/patches/kong-0.11-2/kong.init.lua.patch && \
    # install spec helper lua files
    cp -r /tmp/kong-dev/share/kong-0.11-2/* /usr/local/share/lua/5.1/ && \
    # configure luarocks
    mv /usr/local/etc/luarocks/config-5.1.lua /usr/local/etc/luarocks/config-5.1-default.lua && \
    cp /tmp/kong-dev/etc/luarocks-5.1.conf.lua /usr/local/etc/luarocks/config-5.1.lua && \
    # clean up
    rm -rf /tmp/kong-dev
