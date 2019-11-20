#!/bin/bash
## default variable
DATABASE_NAME=${DATABASE_NAME:-keystone}
DATABASE_USER=${DATABASE_USER:-keystone}
DATABASE_PASSWORD=${DATABASE_PASSWORD:-Welcome123}
DATABASE_HOST=${DATABASE_HOST:-$INTERNAL_API_IP}

TOKEN_EXPIRE=${TOKEN_EXPIRE:-86400}
PRODUCTION=${PRODUCTION:-false}

conf_file=/etc/keystone/keystone.conf

if [[ $PRODUCTION == "true" ]]; then
crudini --set $conf_file DEFAULT public_endpoint $PROTOCOL://$EXTERNAL_API_DOMAIN/identity
crudini --set $conf_file DEFAULT admin_endpoint $PROTOCOL://$INTERNAL_API_DOMAIN/identity
fi
crudini --set $conf_file database connection \
    mysql+pymysql://$DATABASE_USER:$DATABASE_PASSWORD@$DATABASE_HOST/$DATABASE_NAME

crudini --set $conf_file token expiration $TOKEN_EXPIRE

crudini --set $conf_file cache backend_argument url:$INTERNAL_API_IP:11211
