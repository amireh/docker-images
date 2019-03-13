FROM alpine:3.7

RUN apk add --no-cache inotify-tools ruby ruby-json
RUN gem install --no-ri --no-rdoc constancy --version 0.3.1

COPY patches /tmp/patches
RUN sh /tmp/patches/init.sh && rm -r /tmp/patches

VOLUME [ "/etc/constancy.d" ]

COPY bin/constancyd /usr/local/bin/

CMD [ "constancy" ]
