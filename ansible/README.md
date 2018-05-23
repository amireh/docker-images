# amireh/ansible-playbook

A minimal installation of Ansible on Alpine Linux with the Docker client 
allowing Ansible to utilize the `docker` connection to provision containers.

## Usage

```shell
docker run \
    --rm \
    -it \
    -v '/var/run/docker.sock':'/var/run/docker.sock':'ro' \
    -v "${PWD}":'/playbook' \
    -w '/playbook' \
    amireh/ansible-playbook:2.5.3-alpine3.7 \
        ansible-playbook site.yml
```
