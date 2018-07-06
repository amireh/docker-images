import "bb/tasks.sh"
import "../assert.sh"

up() {
  assert.ok "it creates the home directory" \
    docker_run test -d /home/donkey

  assert.eql "it gives user ownership to donkey" \
    a : '1' \
    b : docker_run stat -c '%u' /home/donkey

  assert.eql "it gives group ownership to donkey" \
    a : '1' \
    b : docker_run stat -c '%g' /home/donkey

  assert.ok "it lets donkey write to his home directory" \
    docker_run touch /home/donkey/foo
}

docker_run() {
  docker run \
    --rm \
    -e MIMIC_UID="1" \
    -e MIMIC_GID="1" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(import.resolve '../../bin/mimic')":"/usr/bin/mimic" \
    $IMAGE \
      mimic "$@"
}
