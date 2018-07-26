#!/usr/bin/env bash

cd ci && medusa ansible-playbook ./playbook.yml "$@"
