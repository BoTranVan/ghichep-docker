#!/bin/bash
./configure.sh


if [[ $MISTRAL_SERVER == "api" ]]; then
    echo "Populating database using by mistral ecosystem"
    mistral-db-manage --config-file /etc/mistral/mistral.conf upgrade head
    mistral-db-manage --config-file /etc/mistral/mistral.conf populate
fi

if [[ $MISTRAL_SERVER == "executor" ]]; then
    pip install py-mini-racer
fi

echo "Running service mistral-${MISTRAL_SERVER}"
mistral-server --config-file /etc/mistral/mistral.conf \
               --log-file /var/log/mistral/mistral-${MISTRAL_SERVER}.log \
               --server $MISTRAL_SERVER
