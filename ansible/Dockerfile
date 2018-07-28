FROM alpine:3.7

LABEL MAINTAINER "Ahmad Amireh <ahmad@instructure.com>"

ENV ANSIBLE_VERSION "2.5.3"
ENV DOCKER_VERSION "18.03.1-ce"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk -U update && \
    apk add --upgrade apk-tools && \
    # ansible dependencies
    apk add \
      bash \
      build-base \
      curl \
      git \
      gosu \
      libffi \
      libffi-dev \
      musl-dev \
      openssh \
      openssl \
      openssl-dev \
      py-pip \
      py2-jmespath \
      python \
      python-dev \
      shadow && \
    # install Docker:
    curl https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz | \
    tar -zxC /usr/bin/ --strip-components=1 docker/docker && \
    # upgrade PIP, install Ansible and Docker python bindings
    pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
      ansible==$ANSIBLE_VERSION \
      docker==3.3.0 \
      docker-pycreds==0.2.3 && \
    # clean up
    apk del build-base curl && \
    rm -rf /var/cache/apk/*

COPY bin/ /usr/bin/

ENTRYPOINT [ "/usr/bin/ansible-stash-vault-pass" ]
