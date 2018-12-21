FROM alpine:3.7

RUN apk add --no-cache inotify-tools ruby ruby-json
RUN gem install --no-ri --no-rdoc constancy --version 0.1.5

VOLUME [ "/etc/constancy.d" ]

COPY bin/constancyd /usr/local/bin/

CMD [ "constancy" ]
