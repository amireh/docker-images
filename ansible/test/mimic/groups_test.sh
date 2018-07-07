import "./helpers.sh"

up() {
  assert.eql "it creates the primary group" \
    a : "10" \
    b : docker_run_as "500" "10 15 20 25" mimic id -g

  assert.eql "it creates aux groups" \
    a : "10 15 20 25" \
    b : docker_run_as "500" "10 15 20 25" mimic id -G

  assert.eql "it works even if given 0:0 (root:root) for uid/gid" \
    a : "0" \
    b : docker_run_as "0" "0" mimic id -g
}
