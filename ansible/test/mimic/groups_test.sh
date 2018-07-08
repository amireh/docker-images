import "./helpers.sh"

up() {
  assert.eql "it creates the primary group" \
    a : "10" \
    b : docker_run_as "500" "10 15 20 25" mimic id -g

  if [[ $(uname) =~ "Darwin" ]]; then
    # the gid of the socket on the host may not be the same as in the container
    # so we'll have a mismatch in the assertion, but in practice it doesn't
    # matter because the gid inside the container is (seems to!) always 0 and
    # donkey will become part of that
    echo "skipping 'it creates aux groups' on OS X"
  else
    assert.eql "it creates aux groups" \
      a : "10 15 20 25 $(stat_fmt '%g' /var/run/docker.sock)" \
      b : docker_run_as "500" "10 15 20 25" mimic id -G
  fi

  assert.eql "it works even if given 0:0 (root:root) for uid/gid" \
    a : "0" \
    b : docker_run_as "0" "0" mimic id -g
}
