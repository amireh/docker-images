#!/usr/bin/env bash

P="$(basename "${0}")"

if [[ ! -d ci ]]; then
  echo "$P: must be run from the kong-dev directory" 1>&2
  exit 1
fi

if [[ -z $KONG_VERSION ]]; then
  {
    echo "$P: missing KONG_VERSION environment variable"
    echo "$P: usage example:"
    echo "$P:"
    echo "$P:     KONG_VERSION=0.12.3 ci.sh"
  } 1>&2

  exit 1
fi

type -p medusa 1>/dev/null || {
  {
    echo "$P: \"medusa\" is required to run the tests."
    echo "$P: Refer to the installation notes in the following link"
    echo "$P: and try again:"
    echo "$P:"
    echo "$P:     https://github.com/amireh/medusa#installation"
  } 1>&2

  exit 1
}

cd ci && medusa ansible-playbook ./playbook.yml -e version="$KONG_VERSION" "$@"
