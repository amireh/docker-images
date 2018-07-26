FROM ruby:2.5.1-alpine3.7

MAINTAINER "Ahmad Amireh <ahmad@instructure.com>"

RUN apk add --no-cache --update --virtual .build-deps build-base \
    && apk add --no-cache --update libstdc++ \
    && gem install -N \
           sinatra:2.0.3 \
           sinatra-reloader:1.0.0 \
           thin:1.7.2 \
    && apk del .build-deps

EXPOSE 3000

CMD ["thin", "-c", "/app", "-R", "config.ru", "-p", "3000", "start"]