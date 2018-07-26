#!/usr/bin/env bash

docker run --rm -it \
  -v "$PWD/ci":/mnt/src:ro \
  -v "$PWD/ci/rocks":/usr/local/rocks:ro \
  -v "$PWD/build/coverage":/usr/local/coverage:rw \
  -v "$PWD/patches":/mnt/patches:ro \
  amireh/kong-dev:latest "$@"