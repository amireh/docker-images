FROM alpine:3.7

LABEL MAINTAINER "Ahmad Amireh <ahmad@instructure.com>"

ENV ANSIBLE_VERSION "2.5.3"
ENV DOCKER_VERSION "18.03.1-ce"

RUN apk add --no-cache \
  build-base \
  curl \
  libffi \
  libffi-dev \
  musl-dev \
  python \
  python-dev \
  py-pip \
  openssh \
  openssl \
  openssl-dev

RUN curl https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz | \
    tar -zxC /usr/bin/ --strip-components=1 docker/docker

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
      ansible==$ANSIBLE_VERSION \
      docker==3.3.0 \
      docker-pycreds==0.2.3

RUN apk del --no-cache build-base curl
