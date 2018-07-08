import "../assert.sh"

stat_fmt() {
  if [[ $(uname) =~ "Darwin" ]]; then
    stat -f "$@"
  else
    stat -c "$@"
  fi
}

docker_run_as_me() {
  docker_run_as "$(id -u)" "$(id -G)" "$@"
}

docker_run_as() {
  local uid="$1"
  local gid="$2"

  shift 2

  docker run \
    --rm \
    -e MIMIC_UID="$uid" \
    -e MIMIC_GID="$gid" \
    -e ANSIBLE_VAULT_PASS="${ANSIBLE_VAULT_PASS}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(import.resolve '../../bin/mimic')":"/usr/bin/mimic" \
    $IMAGE \
      "$@"
}
