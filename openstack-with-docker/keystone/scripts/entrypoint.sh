#!/bin/sh

echo "Configure"
    ./configure.sh
echo "sync db and create fernet token"
    keystone-manage db_sync
echo "Config apache"
echo   "ServerName "`getent hosts ${1:-$HOSTNAME} | awk '{print $1}'` >>  /etc/apache2/apache2.conf
echo "bootstrap keystone"
    ./bootstrap.sh
echo "[i] Starting daemon..."
rm -rf /var/run/apache2/*
exec /usr/sbin/apachectl -DFOREGROUND;
