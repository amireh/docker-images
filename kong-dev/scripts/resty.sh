#!/usr/bin/env bash

docker run --rm -it \
  amireh/kong-dev:"${KONG_VERSION:-latest}" \
    /usr/local/openresty/bin/resty "$@"