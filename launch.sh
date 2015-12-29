#!/bin/bash

set -e
#set the DEBUG env variable to turn on debugging
[[ -n "$DEBUG" ]] && set -x

# Environment
HAPROXY_DOMAIN=${HAPROXY_DOMAIN:-router.local}

CONSUL_TEMPLATE=/usr/local/bin/consul-template
CONSUL_LOGLEVEL=${CONSUL_LOGLEVEL:-warn}
CONSUL_MINWAIT=${CONSUL_MINWAIT:-2s}
CONSUL_MAXWAIT=${CONSUL_MAXWAIT:-10s}
CONSUL_CONFIG=${CONSUL_CONFIG:-/router/consul.cfg}
CONSUL_CONNECT=${CONSUL_CONNECT:-consul.service.consul:8500}

DNSMASQ_CONFIG=${DNSMASQ_CONFIG:-/router/dnsmasq.cfg}

function usage {
cat <<USAGE
  launch.sh             Start a consul-backed haproxy instance

Configure using the following environment variables:

HAProxy variables:

  HAPROXY_DOMAIN        Domain for HAProxy routing
                        (default router.local)

Consul-Template variables:

  CONSUL_CONNECT        The consul connection
                        (default consul.service.consul:8500)

  CONSUL_CONFIG         File/directory for consul-template config
                        (/router/consul.cfg)

  CONSUL_LOGLEVEL       Valid values are "debug", "info", "warn", and "err".
                        (default is "warn")

  CONSUL_MINWAIT        Minimum value to wait for consul
                        (default is "2s")

  CONSUL_MAXWAIT        Maximum value to wait for consul
                        (default is "10s")

  CONSUL_TOKEN		      Consul ACL token to use
                        (default is not set)

DNSMasq variables:

  DNSMASQ_CONFIG        Location of the dnsmasq configuration file
                        (default /router/dnsmasq.cfg)

USAGE
}

function launch_haproxy {
    if [ "$(ls -A /usr/local/share/ca-certificates)" ]; then
        cat /usr/local/share/ca-certificates/* >> /etc/ssl/certs/ca-certificates.crt
    fi

    if [ -n "${CONSUL_TOKEN}" ]; then
        ctargs="${ctargs} -token ${CONSUL_TOKEN}"
    fi

    vars=$@

    dnsmasq -C ${DNSMASQ_CONFIG}

    ${CONSUL_TEMPLATE} -config ${CONSUL_CONFIG} \
                       -log-level ${CONSUL_LOGLEVEL} \
                       -wait ${CONSUL_MINWAIT}:${CONSUL_MAXWAIT} \
                       -consul ${CONSUL_CONNECT} ${ctargs} ${vars}
}

launch_haproxy $@
