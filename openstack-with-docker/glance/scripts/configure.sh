#!/bin/bash
## default variable
## database
DATABASE_NAME=${DATABASE_NAME:-glance}
DATABASE_USER=${DATABASE_USER:-glance}
DATABASE_PASS=${DATABASE_PASS:-vccloud}
DATABASE_HOST=${DATABASE_HOST:-$INTERNAL_API_IP}

## service
GLANCE_USER=${GLANCE_USER:-glance}
GLANCE_PASS=${GLANCE_PASS:-vccloud}
DOMAIN_NAME=${DOMAIN_NAME:-Default}
PROJECT_NAME=${PROJECT_NAME:-service}

# IP and Domain
PROTOCOL=${PROTOCOL:-http}

MEMCACHED_HOST=${MEMCACHED_HOST:-$INTERNAL_API_IP}
INTERNAL_API_DOMAIN=${INTERNAL_API_DOMAIN:-$INTERNAL_API_IP}

#Glance stores
GLANCE_STORE=${GLANCE_STORE:-file,http}
DEFAULT_STORE=${DEFAULT_STORE:-file}

PRODUCTION=${PRODUCTION:-false}

api_conf_file=/etc/glance/glance-api.conf

echo "Congfigure glance-api"
crudini --set $api_conf_file DEFAULT verbose True
crudini --set $api_conf_file DEFAULT public_endpoint $BASE_DOMAIN/glance-api

if [[ $PRODUCTION == "true" ]]; then
crudini --set $api_conf_file DEFAULT network_link_prefix /network
fi

crudini --set $api_conf_file database \
connection  mysql+pymysql://$DATABASE_USER:$DATABASE_PASS@$DATABASE_HOST/$DATABASE_NAME
crudini --del $api_conf_file database sqlite_db
if [[ $PRODUCTION == "true" ]]; then
crudini --set $api_conf_file keystone_authtoken \
    www_authenticate_uri $PROTOCOL://$INTERNAL_API_DOMAIN/identity
crudini --set $api_conf_file keystone_authtoken \
    auth_url $PROTOCOL://$INTERNAL_API_DOMAIN/identity
else
crudini --set $api_conf_file keystone_authtoken \
    www_authenticate_uri $PROTOCOL://$INTERNAL_API_DOMAIN:5000
crudini --set $api_conf_file keystone_authtoken \
    auth_url $PROTOCOL://$INTERNAL_API_DOMAIN:5000
fi
crudini --set $api_conf_file keystone_authtoken \
    memcached_servers $MEMCACHED_HOST:11211
crudini --set $api_conf_file keystone_authtoken auth_type password
crudini --set $api_conf_file keystone_authtoken project_domain_name $DOMAIN_NAME
crudini --set $api_conf_file keystone_authtoken user_domain_name $DOMAIN_NAME
crudini --set $api_conf_file keystone_authtoken project_name $PROJECT_NAME
crudini --set $api_conf_file keystone_authtoken username $GLANCE_USER
crudini --set $api_conf_file keystone_authtoken password $GLANCE_PASS


crudini --set $api_conf_file glance_store stores $GLANCE_STORE
crudini --set $api_conf_file glance_store default_store $DEFAULT_STORE

if [ ! -z "$RBD_STORE_POOL" ]; then
crudini --set $api_conf_file glance_store rbd_store_pool $RBD_STORE_POOL
fi 


crudini --set $api_conf_file glance_store rbd_store_user $RBD_STORE_USER
crudini --set $api_conf_file glance_store rbd_store_ceph_conf /etc/ceph/ceph.conf
crudini --set $api_conf_file glance_store rbd_store_chunk_size 8

# configure ceph

if [ ! -z "$CEPH_CLIENT_GLANCE_KEYRING" ]; then
crudini --set /etc/ceph/ceph.client.glance.keyring client.glance key $CEPH_CLIENT_GLANCE_KEYRING
fi
ceph_file=/etc/ceph/ceph.conf

if [ ! -z "$CEPH_FSID" ]; then
crudini --set $ceph_file global fsid $CEPH_FSID
fi

if [ ! -z "$MON_INITIAL_MEMBERS" ]; then
crudini --set $ceph_file global mon_initial_members $MON_INITIAL_MEMBERS
fi

if [ ! -z "$MON_HOST" ]; then
crudini --set $ceph_file global mon_host $MON_HOST
fi

if [ ! -z "$PUBLIC_NETWORK" ]; then
crudini --set $ceph_file global public_network $PUBLIC_NETWORK
fi

if [ ! -z "$CLUSTER_NETWORK" ]; then
crudini --set $ceph_file global cluster_network $CLUSTER_NETWORK
fi
