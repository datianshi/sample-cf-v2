#!/bin/bash
set -e

source lib/common.sh
iaas=$1
check_argument ${iaas}


director=$(bosh-cli int ${iaas}/director.yml --path /internal_ip)
director_name=$(bosh-cli int ${iaas}/director.yml --path /director_name)

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh-cli int ${iaas}/creds.yml --path /admin_password)

if [ "${DRY_RUN}" == "true" ]
then
  cmd="bosh-cli int"
else
  bosh-cli -n -e https://${director}:25555 alias-env ${director_name} \
    --ca-cert <(bosh-cli int ${iaas}/creds.yml --path /default_ca/ca)
  cmd="bosh-cli -n -e ${director_name} update-cloud-config \
       --ca-cert <(bosh-cli int ${iaas}/creds.yml --path /default_ca/ca)"
fi

command="${cmd} ${iaas}/cloud-config.yml \
  -o ${iaas}/reserved_range.yml \
  -o ${iaas}/vm_extension.yml \
  --vars-file ${iaas}/director.yml \
  --vars-file config.yml"

exec $command
# bosh-cli -n -e ${director_name} update-cloud-config ${iaas}/cloud-config.yml \
#   -o ${iaas}/reserved_range.yml \
#   -o ${iaas}/vm_extension.yml \
#   --vars-file ${iaas}/director.yml \
#   --vars-file config.yml \
#   --ca-cert <(bosh-cli int ${iaas}/creds.yml --path /default_ca/ca)
