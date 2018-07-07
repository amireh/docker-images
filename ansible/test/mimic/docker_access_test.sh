import "./helpers.sh"

up() {
  assert.ok 'I can access docker from the host system' \
    docker info

  assert.ok 'I can access docker from the container as root' \
    docker_run_as_me docker info

  assert.ok 'I can access docker from the container as donkey' \
    docker_run_as_me mimic docker info
}
