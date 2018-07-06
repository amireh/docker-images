#!/bin/bash

if [[ -n ${ANSIBLE_VAULT_PASS} ]]; then
  export ANSIBLE_VAULT_PASSWORD_FILE="/tmp/ansible-vault-pass" &&
  echo "${ANSIBLE_VAULT_PASS}" > /tmp/ansible-vault-pass &&
  chmod 0644 /tmp/ansible-vault-pass
fi

exec "$@"