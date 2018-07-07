# amireh/ansible

A minimal (yet extensible) installation of Ansible on Alpine Linux with the
Docker client allowing Ansible to utilize the `docker` connection to provision
containers.

**Table of Contents**

1. [Versions](#versions)
2. [Masquerading](#masquerading)
3. [Volumes](#volumes)
4. [Environment variables](#environment-variables)
5. [Examples](#examples)
    1. [Default run](#default-run)
    2. [Using Docker in Ansible](#using-docker-in-ansible)
    3. [Writing to host directory](#writing-to-host-directory)
    4. [Sticky vault password](#sticky-vault-password)
6. [Changelog](#changelog)

## Versions

- Ansible: 2.5.3
- Docker client: 18.03.1-ce

The image tags follow the format `$ANSIBLE_VERSION-$IMAGE_RELEASE`.

## Masquerading

The image ships with a special program `mimic` that _masquerades_ as a user
(and group) from the host. This makes it possible to preserve permissions when
writing files inside the container to a volume mounted by the host just as if
the modifications were done by the user who ran `docker run` on the host.

Inside the container, the user will **always** have the name `donkey` and their
primary group name will also be called `donkey`. Home directory will be at
`/home/donkey`.

To masquerade, specify the desired user's id and group id(s) in `MIMIC_UID` and
`MIMIC_GID` respectively then run the command through the `mimic` program as
shown below:

```bash
docker run \
  -e MIMIC_UID="$(id -u)" \
  -e MIMIC_GID="$(id -G)" \
  -v "$PWD":"/mnt/src" \
    amireh/ansible:latest \
      mimic \
        touch /mnt/src/foo
```

In the example above, the `foo` file inside the current directory on the host
machine will be owned by the active user.

## Volumes

### `/var/run/docker.sock`

The Docker socket from the host machine.

- This mount is required if the `docker` ansible connection will be used
- This mount is required if any of the `docker_` ansible modules will be used
- This mount can be made read-only

```shell
docker run \
  -v '/var/run/docker.sock':'/var/run/docker.sock':'ro' \
  amireh/ansible:latest \
    ansible-playbook
```

### `/home/donkey/.ssh`

When [masquerading using `mimic`](#masquerading), the host user's `.ssh`
directory can be exposed to replicate the SSH configuration (e.g. authenticate
with the remote hosts, resolve host names, etc.)

- The mount can be made read-only

```shell
docker run \
  -v '/var/run/docker.sock':'/var/run/docker.sock':'ro' \
  -v "$HOME/.ssh":'/home/donkey/.ssh':'ro' \
  -e MIMIC_UID="$(id -u)" \
  -e MIMIC_GID="$(id -G)" \
  amireh/ansible:latest \
    mimic \
      ansible-playbook
```

## Environment variables

### `ANSIBLE_VAULT_PASS`

Type: `string`

Ansible vault password to store in a file to pass to ansible using the
`--vault-password-file` flag. That file will be readable inside the container
only by the user running ansible: either `root` by default or the masquerading
target if using `mimic`.

**Do NOT pass this in clear-text!!!** Doing so will cause the password to be
logged in the shell HISTORY and that would defeat the point. Instead, a keyring
tool like `secret-tool` on Linux can be utilized to look it up privately.

When the warning above is heeded, this becomes a safe and convenient
alternative to being constantly prompted for the password by `--ask-vault-pass`
during long playbook development sessions.

### `MIMIC_GID`

Type: `string | space-separated list`

Groups the masquerading user should be part of when using `mimic`. To get the
list of gids of the groups a user belongs to, use the `id -G` command.

### `MIMIC_UID`

Type: `string`

The UID of the user to masquerade as when using `mimic`. To get the the UID of
a user, use the `id -u` command.

## Examples

### Default run

```bash
docker run --rm -it amireh/ansible ansible -m debug -a 'msg=test' localhost    
```

### Using Docker in Ansible

Mount the docker socket to be able to use the `docker` ansible connection and
run docker tasks:

```bash
docker run --rm -it \
  -v '/var/run/docker.sock':'/var/run/docker.sock':'ro' \
  -v "$PWD":'/mnt/src':'ro' \
  -w '/mnt/src' \
  amireh/ansible \
    ansible-playbook -i ./inventory ./playbook.yml
```

Where the playbook could contain:

```yaml
- hosts: localhost
  tasks:
    docker_container:
      image: nginx:latest
      name: my-nginx
      state: started

- hosts: my-nginx
  tasks:
    - name: configure nginx
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
```

And the inventory would look like this:

```text
[default]
localhost   ansible_connection=local
my-nginx    ansible_connection=docker ansible_host=my-nginx
```

### Writing to host directory

Use `mimic` [as shown previously](#masquerading) and in the task become the
`donkey` user by passing `become: yes` and `become_user: donkey`:

```yaml
- hosts: localhost
  tasks:
    file:
      state: touch
      path: /mnt/src/foo
    become: yes
    become_user: donkey
```

### Sticky vault password

This assumes the host system to be running Linux and has the `secret-tool`
command available.

```bash
# store the password first (this needs to be done only once per password:)
secret-tool store my-service ansible-vault-pass

# now expose it:
docker run --rm -it \
  -e ANSIBLE_VAULT_PASS:"$(secret-tool lookup my-service ansible-vault-pass)" \
  amireh/ansible \
    ansible-playbook ...
```

## Changelog

### 4.0

- the `ansible-extend` script has been removed as its scope falls outside of
  this image. Instead, a custom image can be created based on this one that
  runs `ansible-playbook` in its Dockerfile

### 3.0

- the `ansible-playbook-build` command has been renamed to `ansible-extend` and
  now accepts positional arguments instead of environment variables. The new
  signature becomes:

      ansible-extend TARGET_IMAGE[:TAG] PATH

### 2.3

- Fixed an issue on OS X that was preventing the donkey user from accessing the
  docker socket

### 2.2

- Various minor improvements to the mimic script:
  + It will now ensure that the home directory of `donkey` is present and is
    writable by it

### 2.1

Now possible to store the Ansible vault password to a read-only file inside the
container by passing an environment variable `ANSIBLE_VAULT_PASS`.

### 2.0

Self-provisioning is now possible using the "ansible-playbook-build" script! If
you need extra Ansible modules or perhaps Python dependencies installed inside
the container, you can automatically do that using nothing but Ansible itself.

More info on this can be found in the README.
