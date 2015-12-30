FROM gliderlabs/alpine

MAINTAINER Finbox.io <docker@finbox.io>

RUN apk-install bash haproxy ca-certificates unzip dnsmasq rsyslog

ADD https://releases.hashicorp.com/consul-template/0.12.0/consul-template_0.12.0_linux_amd64.zip /

RUN unzip /consul-template_0.12.0_linux_amd64.zip  && \
    mv /consul-template /usr/local/bin/consul-template && \
    rm -rf /consul-template_0.12.0_linux_amd64.zip

RUN mkdir -p /router

ADD config/ /router

ADD start-router /start-router

ADD rsyslog /etc/rsyslog.d

EXPOSE 53
EXPOSE 80
EXPOSE 9090

CMD ["/start-router"]
