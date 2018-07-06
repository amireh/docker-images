#!/bin/sh

provision() {
  local playbook="${ANSIBLE_CONTAINER_PLAYBOOK}"
  local image="${ANSIBLE_CONTAINER_IMAGE}"

  local current_version="$(sha1sum "${playbook}" | cut -d' ' -f1)"
  local target_image="${image}:${current_version}"
  local latest_image="${image}:latest"

  if [ -n "$(docker image ls -q "${target_image}")" ]; then
    exit 0
  fi

  ansible-playbook -l localhost -c local "${playbook}" || exit $?

  docker image ls -q "${image}" | uniq | xargs docker image rm -f 1>/dev/null

  docker commit --pause="false" "$(hostname)"     "${target_image}"  1>/dev/null &&
  docker tag                    "${target_image}" "${latest_image}"  1>/dev/null
}

provision