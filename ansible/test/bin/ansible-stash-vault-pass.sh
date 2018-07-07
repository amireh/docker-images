import "bb/tasks.sh"
import "../assert.sh"

up() {
  ANSIBLE_VAULT_PASS="foo" \
  assert.eql "it locks down the vault password file" \
    a : '400' \
    b : docker_run sh -c 'stat -c "%a" "${ANSIBLE_VAULT_PASSWORD_FILE}"'

  ANSIBLE_VAULT_PASS="foo" \
  assert.eql "it writes the password inside of it" \
    a : 'foo' \
    b : docker_run sh -c 'cat "${ANSIBLE_VAULT_PASSWORD_FILE}"'
}

docker_run() {
  docker run \
    --rm \
    -e ANSIBLE_VAULT_PASS="${ANSIBLE_VAULT_PASS}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(import.resolve '../../bin/ansible-stash-vault-pass')":'/usr/bin/ansible-stash-vault-pass~latest' \
    --entrypoint="/usr/bin/ansible-stash-vault-pass~latest" \
    $IMAGE \
      "$@"
}
