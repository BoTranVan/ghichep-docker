#!/bin/bash
set -o xtrace

function add_config {
    crudini --set $1 $2 $3 $4;
}


# config default
# ENV
DEBUG=${DEBUG:-'true'}
SENLIN_HOST=${SENLIN_HOST:-senlin}
TRANSPORT_URL=${TRANSPORT_URL}
NUM_ENGINE_WORKERS=${NUM_ENGINE_WORKERS:-2}
NUM_CONDUCTOR_WORKERS=${NUM_CONDUCTOR_WORKERS:-2}
NUM_HEALTH_MANAGER_WORKERS=${NUM_HEALTH_MANAGER_WORKERS:-2}
# config database
DB_NAME=${DB_NAME:-senlin}
DB_USERNAME=${DB_USERNAME:-senlin}
DB_PASSWD=${DB_PASSWD:-Welcome123}
DB_HOST=${DB_HOST}
# config service
AUTH_URL=${AUTH_URL}
WWW_AUTHENTICATE_URI=${WWW_AUTHENTICATE_URI:-${AUTH_URL}}
MEMCACHED_SERVERS=${MEMCACHED_SERVERS}
SENLIN_USER=${SENLIN_USER:-senlin}
SENLIN_PASS=${SENLIN_PASS:-Welcome123}
SENLIN_USER_DOMAIN=${SENLIN_USER_DOMAIN:-Default}
SENLIN_PROJECT=${SENLIN_PROJECT:-service}
SENLIN_PROJECT_DOMAIN=${SENLIN_PROJECT_DOMAIN:-Default}

# config api
SENLIN_PORT=${SENLIN_PORT:-8777}
SENLIN_WORKERS=${SENLIN_WORKERS:-2}

config_file="/etc/senlin/senlin.conf"
log_dir="/var/log/senlin"


# Check log dir exists.
if [[ ! -d $log_dir ]]; then
    echo "Making log dir ..."
    mkdir $log_dir
fi

# Check file log exists.
if [[ ! -d $log_dir/senlin-${PROCESS} ]]; then
    echo "Making file log $log_dir/senlin-${PROCESS}"
    touch $log_dir/senlin-${PROCESS}.log
fi


# Generate configuration file for the Senlin service.
# cd /opt/senlin/
# ./tools/gen-config
# mkdir /etc/senlin ${log_dir}
# cp /opt/senlin/etc/senlin/api-paste.ini /etc/senlin
# cp /opt/senlin/etc/senlin/senlin.conf.sample ${config_file}

# Generate policy file for Senlin service
# cd /opt/senlin/
# ./tools/gen-policy
# mv /opt/senlin/etc/senlin/policy.yaml.sample /etc/senlin/policy.yaml

# Edit file /etc/senlin/senlin.conf according to your system settings.
add_config ${config_file} DEFAULT debug ${DEBUG}
add_config ${config_file} DEFAULT log_dir ${log_dir}
add_config ${config_file} DEFAULT transport_url ${TRANSPORT_URL}
add_config ${config_file} DEFAULT host ${SENLIN_HOST}
add_config ${config_file} DEFAULT health_check_interval_min 30

# Config for senlin conductor
add_config ${config_file} conductor workers ${NUM_CONDUCTOR_WORKERS}

# Config for senlin engine
add_config ${config_file} engine workers ${NUM_ENGINE_WORKERS}

# Config for senlin health_manager
add_config ${config_file} health_manager workers ${NUM_HEALTH_MANAGER_WORKERS}

add_config ${config_file} database connection mysql+pymysql://${DB_USERNAME}:${DB_PASSWD}@${DB_HOST}/${DB_NAME}?charset=utf8

add_config ${config_file} keystone_authtoken auth_url ${AUTH_URL}
add_config ${config_file} keystone_authtoken www_authenticate_uri ${WWW_AUTHENTICATE_URI}
add_config ${config_file} keystone_authtoken memcached_servers ${MEMCACHED_SERVERS}
add_config ${config_file} keystone_authtoken username ${SENLIN_USER}
add_config ${config_file} keystone_authtoken password ${SENLIN_PASS}
add_config ${config_file} keystone_authtoken project_name ${SENLIN_PROJECT}
add_config ${config_file} keystone_authtoken project_domain_name ${SENLIN_PROJECT_DOMAIN}
add_config ${config_file} keystone_authtoken user_domain_name ${SENLIN_USER_DOMAIN}
add_config ${config_file} keystone_authtoken auth_type password
add_config ${config_file} keystone_authtoken service_token_roles_required True

add_config ${config_file} authentication auth_url ${AUTH_URL}
add_config ${config_file} authentication service_username ${SENLIN_USER}
add_config ${config_file} authentication service_password ${SENLIN_PASS}
add_config ${config_file} authentication service_project_name ${SENLIN_PROJECT}

add_config ${config_file} health_manager nova_control_exchange nova
add_config ${config_file} health_manager enabled_endpoints nova

# add_config ${config_file} oslo_messaging_rabbit rabbit_userid ${RABBIT_USERID}
# add_config ${config_file} oslo_messaging_rabbit rabbit_hosts ${RABBIT_HOSTS}
# add_config ${config_file} oslo_messaging_rabbit rabbit_password ${RABBIT_PASSWORD}

add_config ${config_file} oslo_messaging_notifications driver messaging

#add_config ${config_file} oslo_policy policy_file policy.yaml

add_config ${config_file} senlin_api bind_port ${SENLIN_PORT}
add_config ${config_file} senlin_api workers ${SENLIN_WORKERS}

set +o xtrace


