#!/bin/bash

BUILD_APP=$1
REPLICAS=$2
CHANGE_APP_IMAGE=$3

export SEDCMD='/usr/bin/env sed'
export KUBECTL='/usr/bin/env kubectl'

function log_message {
  message=$1
  echo -e "\033[1m[$(date)] ${message} ...\033[0m"
}

DEPLOYMENT_FILE=deployment.yaml

log_message "Generating deployment.yaml"
${SEDCMD} \
  -e "s|CHANGE_APP_NAME|${BUILD_APP}|" \
  -e "s|CHANGE_APP_IMAGE|${CHANGE_APP_IMAGE}|" \
  -e "s|CHANGE_APP_URL|${APP_URL}|" \
  -e "s|CHANGE_REPLICAS|${REPLICAS}|" \
  deployment.tpl > ${DEPLOYMENT_FILE}

echo -e "\033[1m[$(date)] ${DEPLOYMENT_FILE} ...\033[0m"

${KUBECTL} apply -f ${DEPLOYMENT_FILE}

${KUBECTL} -n gtd patch deployment $BUILD_APP -p '{"spec":{"template":{"metadata":{"annotations":{"date": "'$(date +%s)'"}}}}}'

${KUBECTL} -n gtd rollout status deploy/$BUILD_APP

INGRESS_FILE=ingress.yaml
log_message "Generating ingress.yaml"

${SEDCMD} \
  -e "s|CHANGE_APP_NAME|${BUILD_APP}|" \
  -e "s|CHANGE_APP_URL|${APP_URL}|" \
  apps/${BUILD_APP}/.kubernetes/ingress.tpl > ${INGRESS_FILE}

echo -e "\033[1m[$(date)] ${INGRESS_FILE} ...\033[0m"

${KUBECTL} apply -f ${INGRESS_FILE}