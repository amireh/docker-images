# amireh/ansible

A minimal (yet extensible) installation of Ansible on Alpine Linux with the
Docker client allowing Ansible to utilize the `docker` connection to provision
containers.

## Usage

```bash
docker run \
    --rm \
    -it \
    -v '/var/run/docker.sock':'/var/run/docker.sock':'ro' \
    -v "${PWD}":'/playbook' \
    -w '/playbook' \
    amireh/ansible:latest \
        ansible-playbook site.yml
```

## Features

### Preserving host permissions

_TODO_ write about `mimic`

### Extending Ansible

_TODO_ write about ansible-playbook-build

### Vault password entry

_TODO_ write about stash-vault-password

## Changelog

### 2.3

- Fixed an issue on OS X that was preventing the donkey user from accessing the
  docker socket

### 2.1

Now possible to store the Ansible vault password to a read-only file inside the
container by passing an environment variable `ANSIBLE_VAULT_PASS`.

### 2.0

Self-provisioning is now possible using the "ansible-playbook-build" script! If
you need extra Ansible modules or perhaps Python dependencies installed inside
the container, you can automatically do that using nothing but Ansible itself.

More info on this can be found in the README.
