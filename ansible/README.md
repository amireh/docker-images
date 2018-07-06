# amireh/ansible

A minimal (yet extensible) installation of Ansible on Alpine Linux with the
Docker client allowing Ansible to utilize the `docker` connection to provision
containers.

## Usage

```shell
docker run \
    --rm \
    -it \
    -v '/var/run/docker.sock':'/var/run/docker.sock':'ro' \
    -v "${PWD}":'/playbook' \
    -w '/playbook' \
    amireh/ansible:latest \
        ansible-playbook site.yml
```

## Preserving host permissions

_TODO_ write about `mimic`

## Customizing Ansible

_TODO_ write about ansible-playbook-build

## Convenient and safe vault password entry

_TODO_ write about stash-vault-password
