import "bb/tasks.sh"
import "../assert.sh"

up() {
  assert.ok 'it prints the help listing' \
    docker_run ansible-extend --help

  assert.ok 'it builds another image' \
    docker_run ansible-extend amireh/ansible-extension-test /playbook/extensions.yml

  IMAGE="amireh/ansible-extension-test:latest" \
  assert.ok 'it runs the playbook' \
    docker_run test -f /ansible-extension
}

docker_run() {
  docker run \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(import.resolve '../fixture')":"/playbook" \
    -v "$(import.resolve '../../bin/ansible-extend')":"/usr/bin/ansible-extend" \
    $IMAGE \
      "$@"
}
