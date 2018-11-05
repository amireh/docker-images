#!/usr/bin/env bash

test -f example/main.sh || {
  echo "$0: must be run from ansible-dev root" 1>&2
  exit 1
}

ansible-dev() {
  docker run \
    --rm -it \
    -v "$PWD/example":/mnt/src \
    -w /mnt/src \
    -e MIMIC_UID="$(id -u)" \
    -e MIMIC_GID="$(id -g)" \
      amireh/ansible-dev:"${VERSION:-latest}" "$@"
}

# https://www.pylint.org/
# lint source code using PyLint
pylint() {
  ansible-dev pylint ./src
}

# https://docs.pytest.org/en/latest/
# unit tests using PyTest
pytest() {
  ansible-dev python -B -m pytest ./
}

# https://pytest-cov.readthedocs.io/en/latest/
# unit tests + coverage using pytest-cov
pytest_pycov() {
  ansible-dev python -B -m pytest --cov=./src ./
}

ansible-docgen() {
  ansible-dev sh -c 'MODULE="mod" FILES="src/mod.py" ansible-docgen'
}

pylint &&
pytest &&
pytest_pycov &&
ansible-docgen