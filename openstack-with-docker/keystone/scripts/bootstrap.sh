#!/bin/sh

echo "Create fernet directory"
mkdir -p /etc/keystone/fernet-keys/
chmod 700 /etc/keystone/fernet-keys/
keystone-manage fernet_rotate --keystone-user keystone --keystone-group keystone
chmod 600 -R /etc/keystone/fernet-keys/*
chown -R keystone:keystone /etc/keystone/fernet-keys/

## setting variable
ADMIN_USER=${ADMIN_USER:-admin}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-Welcome123}
ADMIN_PROJECT=${ADMIN_PROJECT:-admin}

ADMIN_ROLE=${ADMIN_ROLE:-admin}
REGION_NAME=${REGION_NAME:-RegionOne}

## domain identity

EXTERNAL_API_DOMAIN=${EXTERNAL_API_DOMAIN:-$EXTERNAL_API_IP}
INTERNAL_API_DOMAIN=${INTERNAL_API_DOMAIN:-$INTERNAL_API_IP}

PROTOCOL=${PROTOCOL:-http}
PRODUCTION=${PRODUCTION:-false}

if [[ $PRODUCTION == "true" ]]; then
keystone-manage bootstrap \
    --bootstrap-password $ADMIN_PASSWORD \
    --bootstrap-username $ADMIN_USER \
    --bootstrap-project-name $ADMIN_PROJECT \
    --bootstrap-role-name $ADMIN_ROLE \
    --bootstrap-service-name keystone \
    --bootstrap-region-id $REGION_NAME \
    --bootstrap-admin-url $PROTOCOL://$INTERNAL_API_DOMAIN/identity/v3 \
    --bootstrap-public-url $PROTOCOL://$EXTERNAL_API_DOMAIN/identity/v3 \
    --bootstrap-internal-url $PROTOCOL://$INTERNAL_API_DOMAIN/identity/v3

else
keystone-manage bootstrap \
    --bootstrap-password $ADMIN_PASSWORD \
    --bootstrap-username $ADMIN_USER \
    --bootstrap-project-name $ADMIN_PROJECT \
    --bootstrap-role-name $ADMIN_ROLE \
    --bootstrap-service-name keystone \
    --bootstrap-region-id $REGION_NAME \
    --bootstrap-admin-url $PROTOCOL://$INTERNAL_API_DOMAIN:5000/v3 \
    --bootstrap-public-url $PROTOCOL://$EXTERNAL_API_DOMAIN:5000/v3 \
    --bootstrap-internal-url $PROTOCOL://$INTERNAL_API_DOMAIN:5000/v3
fi
