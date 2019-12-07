#! /bin/bash
echo "Configure glance"
    ./configure.sh
if [ "$PROCESS" == "api" ];then
    echo "Sync database"
    glance-manage db_sync
fi
echo "Starting glance-"$PROCESS
    glance-$PROCESS --config-file=/etc/glance/glance-$PROCESS.conf --log-file=/var/log/glance/glance-$PROCESS.log
