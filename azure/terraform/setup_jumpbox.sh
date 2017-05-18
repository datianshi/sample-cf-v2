#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TSTATE_FILE="${DIR}/terraform.tfstate"
ENV_FILE="${DIR}/env.sh"


JUMPBOX_IP=$(terraform state show -state ${TSTATE_FILE} azurerm_public_ip.jb-public-ip | grep ip_address | head -n 1 | awk '{print $3}')


ssh -i ${PRIVATE_KEY_PATH} ubuntu@${JUMPBOX_IP} 'rm -rf sample-cf-v2 && git clone https://github.com/datianshi/sample-cf-v2'
scp -i ${PRIVATE_KEY_PATH} ${TSTATE_FILE} ${ENV_FILE} ubuntu@${JUMPBOX_IP}:./sample-cf-v2/azure/terraform/
