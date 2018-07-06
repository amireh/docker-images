import "bb/tasks.sh"
import "../assert.sh"

up() {
  assert.ok 'has access to docker on host system' \
    docker info

  assert.ok 'container has access to docker as root' \
    docker_run docker info

  assert.ok 'container has access to docker as donkey' \
    docker_run mimic docker info
}

docker_run() {
  docker run \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(import.resolve '../../bin/mimic')":"/usr/bin/mimic" \
    -e MIMIC_UID="$(id -u)" \
    -e MIMIC_GID="$(id -G)" \
    $IMAGE "$@"
}
