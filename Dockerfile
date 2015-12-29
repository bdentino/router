FROM gliderlabs/alpine

MAINTAINER Finbox.io <docker@finbox.io>

ENV CONSUL_TEMPLATE_VERSION=0.11.1

RUN apk-install bash haproxy ca-certificates unzip dnsmasq rsyslog

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /

RUN unzip /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip  && \
    mv /consul-template /usr/local/bin/consul-template && \
    rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

RUN mkdir -p /router

ADD config/ /router

ADD launch.sh /launch.sh

EXPOSE 53
EXPOSE 80
EXPOSE 9090

CMD ["/launch.sh"]
