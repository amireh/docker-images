import "./helpers.sh"

up() {
  ANSIBLE_VAULT_PASS="foo" \
  assert.eql "rewires ownership of the vault password file to donkey" \
    a : "$(id -u)" \
    b : docker_run_as_me mimic sh -c 'stat -c "%u" "${ANSIBLE_VAULT_PASSWORD_FILE}"'
}
