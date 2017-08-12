#!/bin/bash
set -e

source lib/common.sh
iaas=$1
check_argument ${iaas}


director=$(bosh-cli int ${iaas}/director.yml --path /internal_ip)
director_name=$(bosh-cli int ${iaas}/director.yml --path /director_name)

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh-cli int ${iaas}/creds.yml --path /admin_password)

bosh-cli -n -e https://${director}:25555 alias-env ${director_name} \
  --ca-cert <(bosh-cli int ${iaas}/creds.yml --path /default_ca/ca)


bosh-cli -n -e ${director_name} update-cpi-config ${iaas}/cpi-config.yml \
  --vars-file ${iaas}/director.ym \
  --ca-cert <(bosh-cli int ${iaas}/creds.yml --path /default_ca/ca)
