import "./helpers.sh"

up() {
  assert.ok "it creates the home directory" \
    docker_run_as_me mimic test -d /home/donkey

  assert.eql "it gives user ownership of home to donkey" \
    a : '1' \
    b : docker_run_as 1 1 mimic stat -c '%u' /home/donkey

  assert.eql "it gives group ownership of home to donkey" \
    a : '1' \
    b : docker_run_as 1 1 mimic stat -c '%g' /home/donkey

  assert.ok "it does let donkey write to his home directory" \
    docker_run_as_me mimic touch /home/donkey/foo

  assert.eql "does not attempt to chown bound volumes inside home" \
    a : 'donkey' \
    b : docker run \
        --rm \
        -e MIMIC_UID="$(id -u)" \
        -e MIMIC_GID="$(id -G)" \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "${HOME}/.ssh":"/home/donkey/.ssh":"ro" \
        -v "$(import.resolve '../../bin/mimic')":"/usr/bin/mimic" \
        $IMAGE \
          mimic stat -c '%U' /home/donkey
}
