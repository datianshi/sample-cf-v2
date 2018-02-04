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
  -o bosh-deployment/credhub.yml \
  -o bosh-deployment/misc/dns.yml \
  -o bosh-deployment/${iaas}/cpi.yml \
  -o kubo-deployment/configurations/generic/bosh-admin-client.yml \
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

bosh update-runtime-config -n "bosh-deployment/runtime-configs/dns.yml"
