FROM ruby:2.5.1-alpine3.7

LABEL MAINTAINER "Ahmad Amireh <ahmad@instructure.com>"

RUN apk add --no-cache xz

COPY src /usr/

CMD [ "dvs-pack" ]
