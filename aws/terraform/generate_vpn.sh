#!/bin/bash

set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TSTATE_FILE="${DIR}/terraform.tfstate"
AZURE_TSTATE_FILE="${DIR}/../../azure/terraform/terraform.tfstate"

RESOURCE_GROUP=$(terraform state show -state ${AZURE_TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep name | awk '{print $3}')
export RIGHT_SUBNET_CIDR=$(terraform state show -state ${AZURE_TSTATE_FILE} azurerm_virtual_network.pcf_virtual_network | grep address_space.0 | awk '{print $3}')
export PUBLIC_RIGHT_IP=$(azure network public-ip show vpn-public-ip --resource-group ${RESOURCE_GROUP} --json | jq -r .ipAddress)
export PSK_SECRET=abcdefgh
export LOCAL_IP=$(terraform state show -state ${TSTATE_FILE} module.vpn.aws_instance.strongswan | grep private_ip | awk '{print $3}')
export PUBLIC_LEFT_IP=$(terraform state show -state ${TSTATE_FILE} module.vpn.aws_eip.vpn_ip | grep public_ip | awk '{print $3}')

erb vpn/ipsec.conf.tpl > ipsec.conf
erb vpn/ipsec.secrets.tpl > ipsec.secrets

scp -i ${PRIVATE_KEY_PATH} ipsec.conf ipsec.secrets ubuntu@${PUBLIC_LEFT_IP}:./
ssh -i ${PRIVATE_KEY_PATH} ubuntu@${PUBLIC_LEFT_IP} 'sudo mv /home/ubuntu/ipsec.* /etc/ && sudo ipsec restart'
