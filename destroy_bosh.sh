#!/bin/bash
set -e

source lib/common.sh
iaas=$1
check_argument ${iaas}


bosh-cli delete-env bosh-deployment/bosh.yml \
  --state ./${iaas}/state.json \
  -o bosh-deployment/${iaas}/cpi.yml \
  --vars-store ${iaas}/creds.yml \
  --vars-file ${iaas}/director.yml
