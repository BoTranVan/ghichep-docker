#!/bin/bash
./configure.sh


if [ "${PROCESS}" == "api" ]; then
    echo "Populating database ..."
    senlin-manage db_sync
fi

if [[ "${PROCESS}" == "aio" ]]; then
   echo "Clustering service is running in mode All-In-One"
   senlin-api --config-file /etc/senlin/senlin.conf --log-file /var/log/senlin/senlin-api.log &
   senlin-engine --config-file /etc/senlin/senlin.conf --log-file /var/log/senlin/senlin-engine.log &
   senlin-conductor --config-file /etc/senlin/senlin.conf --log-file /var/log/senlin/senlin-conductor.log &
   senlin-health-manager --config-file /etc/senlin/senlin.conf --log-file /var/log/senlin/senlin-health-manager.log
else
   echo "senlin-${PROCESS} service is running."
   senlin-${PROCESS} --config-file /etc/senlin/senlin.conf --log-file /var/log/senlin/senlin-${PROCESS}.log

fi
