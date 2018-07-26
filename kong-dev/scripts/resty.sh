#!/usr/bin/env bash

docker run --rm -it amireh/kong-dev:latest /usr/local/openresty/bin/resty "$@"