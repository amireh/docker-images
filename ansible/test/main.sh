#!/usr/bin/env bash

if [[ ! -s ~/'.bishbash/import.sh' ]]; then
  mkdir -p ~/'.bishbash'
  curl -sS -f 'https://raw.githubusercontent.com/amireh/bishbash/2a73e7007bd52c0fd312b505144e4cf853169534/modules/bb/import.sh' > ~/'.bishbash/import.sh'
fi

source ~/'.bishbash/import.sh'

import.add_package 'bb' 'github:amireh/bishbash#2a73e7007bd52c0fd312b505144e4cf853169534/modules'
import "bb/tasks.sh"

export IMAGE="amireh/ansible:${VERSION:-latest}"

tasks.define 'bin/ansible-extend'
tasks.define 'bin/ansible-stash-vault-pass'
tasks.define 'mimic/docker_access_test'
tasks.define 'mimic/groups_test'
tasks.define 'mimic/home_test'
tasks.define 'mimic/vault_file_test'
tasks.read_wants $@

shift $?

if tasks.wants_help; then
  tasks.print_help "$(import.resolve "./")"
else
  tasks.run_all "$(import.resolve "./")" "${1:-up}"
fi
