#!/bin/bash

set -o xtrace

function add_config {
    crudini --set $1 $2 $3 $4;
}

ADMIN_DOMAIN_NAME=${ADMIN_DOMAIN_NAME:-"Default"}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-"Welcome123"}
ADMIN_TENANT_NAME=${ADMIN_TENANT_NAME:-"service"}
ADMIN_USER=${ADMIN_USER:-"mistral"}
AUTH_ENABLE=${AUTH_ENABLE:-"False"}
AUTH_TYPE=${AUTH_TYPE:-'keystone'}
AUTH_URL=${AUTH_URL:-"http://127.0.0.1:5000/v3"}
DEFAULT_REGION_NAME=${DEFAULT_REGION_NAME:-"RegionOne"}
JS_IMPLEMENTATION=${JS_IMPLEMENTATION:-'py_mini_racer'}
KEYSTONE_AUTH_TYPE=${KEYSTONE_AUTH_TYPE:-"password"}
EXECUTION_FIELD_SIZE_LIMIT_KB=${EXECUTION_FIELD_SIZE_LIMIT_KB:-4096}
MISTRAL_CONF="/etc/mistral/mistral.conf"
STRR=${STRR:-"True"}
log_dir="/var/log/mistral"
# Check log dir exists.
if [[ ! -d $log_dir ]]; then
    echo "Making log dir $log_dir"
    mkdir $log_dir
fi


add_config $MISTRAL_CONF DEFAULT auth_type ${AUTH_TYPE}
add_config $MISTRAL_CONF DEFAULT js_implementation ${JS_IMPLEMENTATION}
add_config $MISTRAL_CONF pecan auth_enable ${AUTH_ENABLE}
add_config $MISTRAL_CONF engine execution_field_size_limit_kb ${EXECUTION_FIELD_SIZE_LIMIT_KB}

if [[ $AUTH_TYPE == "keycloak_oidc" ]]; then
    add_config $MISTRAL_CONF keycloak_oidc auth_url ${AUTH_URL}
    add_config $MISTRAL_CONF keycloak_oidc insecure true
fi

if [[ $AUTH_ENABLE == "True" ]]; then
    # When pecan.auth_enable == true, we need config authentication
    add_config $MISTRAL_CONF keystone_authtoken auth_url ${AUTH_URL}
    add_config $MISTRAL_CONF keystone_authtoken password ${ADMIN_PASSWORD}
    add_config $MISTRAL_CONF keystone_authtoken project_domain_name ${ADMIN_DOMAIN_NAME}
    add_config $MISTRAL_CONF keystone_authtoken project_name ${ADMIN_TENANT_NAME}
    add_config $MISTRAL_CONF keystone_authtoken user_domain_name ${ADMIN_DOMAIN_NAME}
    add_config $MISTRAL_CONF keystone_authtoken username ${ADMIN_USER}
    add_config $MISTRAL_CONF keystone_authtoken service_token_roles_required ${STRR}
fi

if [[ $AUTH_TYPE == "keystone" ]]; then
    add_config $MISTRAL_CONF keystone_authtoken admin_password ${ADMIN_PASSWORD}
    add_config $MISTRAL_CONF keystone_authtoken admin_tenant_name ${ADMIN_TENANT_NAME}
    add_config $MISTRAL_CONF keystone_authtoken admin_user ${ADMIN_USER}
    add_config $MISTRAL_CONF keystone_authtoken auth_type ${KEYSTONE_AUTH_TYPE}
    add_config $MISTRAL_CONF keystone_authtoken region_name ${DEFAULT_REGION_NAME}
    add_config $MISTRAL_CONF keystone_authtoken auth_uri ${AUTH_URL}
    add_config $MISTRAL_CONF keystone_authtoken www_authenticate_uri ${AUTH_URL}

fi

add_config $MISTRAL_CONF api allow_action_execution_deletion True
add_config $MISTRAL_CONF database connection "${DATABASE_URL}"
add_config $MISTRAL_CONF database max_overflow -1
add_config $MISTRAL_CONF database max_pool_size 1000
add_config $MISTRAL_CONF DEFAULT debug "${LOG_DEBUG}"
add_config $MISTRAL_CONF DEFAULT transport_url "${MESSAGE_BROKER_URL}"
add_config $MISTRAL_CONF openstack_actions default_region ${DEFAULT_REGION_NAME}

set +o xtrace