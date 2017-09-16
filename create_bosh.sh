#!/bin/bash
set -e

source lib/common.sh
iaas=$1
check_argument ${iaas}


cmd="bosh-cli create-env --state ./${iaas}/state.json"
if [ "${DRY_RUN}" == "true" ]
then
  cmd="bosh-cli int"
fi

command="$cmd bosh-deployment/bosh.yml \
  -o bosh-deployment/uaa.yml \
  -o bosh-deployment/config-server.yml \
  -o bosh-deployment/${iaas}/cpi.yml \
  -o trusted_certs_ops.yml \
  --vars-store ${iaas}/creds.yml \
  --vars-file ${iaas}/director.yml"

echo $command
exec $command
# bosh-cli create-env bosh-deployment/bosh.yml \
#   --state ./${iaas}/state.json \
#   -o bosh-deployment/${iaas}/cpi.yml \
#   --vars-store ${iaas}/creds.yml \
#   --vars-file ${iaas}/director.yml
