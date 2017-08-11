#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TSTATE_FILE="${DIR}/terraform.tfstate"
ENV_FILE="${DIR}/env.sh"


JUMPBOX_IP=$(terraform state show -state ${TSTATE_FILE} aws_instance.jumpbox | grep public_ip | tail -n 1 | awk '{print $3}')


ssh -i ${PRIVATE_KEY_PATH} ubuntu@${JUMPBOX_IP} 'rm -rf sample-cf-v2 && git clone -b vpc-peering https://github.com/datianshi/sample-cf-v2'
ssh -i ${PRIVATE_KEY_PATH} ubuntu@${JUMPBOX_IP} 'cd sample-cf-v2 && git submodule init && git submodule update'
scp -i ${PRIVATE_KEY_PATH} ${TSTATE_FILE} ${ENV_FILE} ${PRIVATE_KEY_PATH} ubuntu@${JUMPBOX_IP}:./sample-cf-v2/aws/terraform/
