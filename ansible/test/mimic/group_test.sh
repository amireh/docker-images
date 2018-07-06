import "bb/tasks.sh"
import "../assert.sh"

up() {
  assert.eql "it creates the primary group" \
    a : "10" \
    b : run_with_uid_gid "500" "10 15 20 25" id -g

  assert.eql "it creates aux groups" \
    a : "10 15 20 25" \
    b : run_with_uid_gid "500" "10 15 20 25" id -G

  assert.eql "works even if given 0:0 (root:root)" \
    a : "0" \
    b : run_with_uid_gid "0" "0" id -g
}

run_with_uid_gid() {
  local uid="$1"
  local gid="$2"

  shift 2

  docker run \
    --rm \
    -e MIMIC_UID="$uid" \
    -e MIMIC_GID="$gid" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(import.resolve '../../bin/mimic')":"/usr/bin/mimic" \
    $IMAGE \
      mimic "$@"
}
