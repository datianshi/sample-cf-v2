#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TSTATE_FILE="${DIR}/terraform.tfstate"
ENV_FILE="${DIR}/env.sh"
ACCOUNT_FILE="${DIR}/account.json"


gcloud compute ssh bosh-bastion --command 'rm -rf sample-cf-v2 && git clone https://github.com/datianshi/sample-cf-v2' --zone $TF_VAR_zone
gcloud compute ssh bosh-bastion --command 'cd sample-cf-v2 && git submodule init && git submodule update' --zone $TF_VAR_zone
gcloud compute copy-files "${PRIVATE_KEY_PATH}" ${TSTATE_FILE} ${ACCOUNT_FILE} ${ENV_FILE} bosh-bastion:~/sample-cf-v2/gcp/terraform/ --zone $TF_VAR_zone
