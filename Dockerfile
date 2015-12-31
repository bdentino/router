FROM gliderlabs/alpine

MAINTAINER Finbox.io <docker@finbox.io>

RUN apk-install bash haproxy ca-certificates unzip dnsmasq rsyslog supervisor

ADD consul-template /usr/local/bin/consul-template

RUN chmod +rx /usr/local/bin/consul-template

RUN mkdir -p /router

ADD config/ /router

ADD start-router /start-router

ADD rsyslog /etc/rsyslog.d

ADD supervisord.conf /supervisord.conf

EXPOSE 53
EXPOSE 80
EXPOSE 9090

CMD ["/start-router"]
