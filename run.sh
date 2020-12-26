#!/bin/bash

if [[ ! -z "${IOTA_USER}" ]]; then
    sed -i -e "s/user=iota/user=$IOTA_USER/g" /etc/supervisord.conf
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf
