#!/bin/bash

RUN_GROUP="donkey"
RUN_USER="donkey"
RUN_GID=
RUN_UID="${MIMIC_UID}"

if [[ -z $MIMIC_UID ]]; then
  echo "$0: missing MIMIC_UID (pass \`id -u\`)" 1>&2
  exit 1
fi

if [[ -z $MIMIC_GID ]]; then
  echo "$0: missing MIMIC_GID (pass \`id -G\`)" 1>&2
  exit 1
fi

create_primary_group() {
  IFS=" " local gids=( $MIMIC_GID )

  RUN_GID="${gids[0]}"

  groupadd --non-unique --gid "${RUN_GID}" "${RUN_GROUP}"
}

create_additional_groups() {
  local letter="a"
  IFS=" " local gids=( $MIMIC_GID )

  for gid in "${gids[@]}"; do
    if [[ $gid == ${RUN_GID} ]]; then
      continue
    fi

    local group="mimic-$letter"

    groupadd --non-unique --gid $gid "$group" &&
    usermod  -a -G "$group" "$RUN_USER" || {
      echo "mimic: unable to create group with gid $gid ($group)" 1>&2
      exit $?
    }

    letter="$(echo "$letter" | tr "0-9a-z" "1-9a-z_")"
  done
}

create_user() {
  echo "CREATE_MAIL_SPOOL=no" >> /etc/default/useradd &&
  useradd \
    --no-create-home \
    --uid "$RUN_UID" \
    --gid "$RUN_GID" \
    --no-log-init \
    --non-unique \
    --shell /bin/sh \
      "$RUN_USER"
}


create_home() {
  if [ ! -d "/home/$RUN_USER" ]; then
    mkdir -p "/home/$RUN_USER" || exit $?
  fi

  chown -R "$RUN_USER:$RUN_GROUP" "/home/$RUN_USER" 2>/dev/null || true
}

grant_docker_acces_to_donkey() {
  usermod -a -G "$(stat -c '%g' /var/run/docker.sock)" "$RUN_USER"
  # chown "$RUN_USER:$RUN_GROUP" /var/run/docker.sock
}

create_primary_group &&
create_user &&
create_home &&
create_additional_groups &&
grant_docker_acces_to_donkey &&
gosu "${MIMIC_UID}" "$@"
