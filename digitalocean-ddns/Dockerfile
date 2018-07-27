FROM alpine:3.7

RUN apk add --no-cache \
      bash \
      bind-tools \
      curl \
      jq

ENV DO_DOMAIN="" \
    DO_RECORD="" \
    DO_TOKEN="" \
    FREQUENCY="60" \
    PEDANTIC="0" \
    PROGRESS="0"

COPY bin/* /usr/local/bin/

ENTRYPOINT ["docker-entrypoint"]

CMD ["digitalocean-ddns"]