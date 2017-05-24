#!/bin/bash

set -ex

export PUBLIC_RIGHT_IP=40.83.151.130
export PSK_SECRET=abcdefgh
export LOCAL_IP=$(terraform state show module.vpn.aws_instance.strongswan | grep private_ip | awk '{print $3}')
export PUBLIC_LEFT_IP=$(terraform state show module.vpn.aws_eip.vpn_ip | grep public_ip | awk '{print $3}')

erb vpn/ipsec.conf.tpl > ipsec.conf
erb vpn/ipsec.secrets.tpl > ipsec.secrets

scp -i ${PRIVATE_KEY_PATH} ipsec.conf ipsec.secrets ubuntu@${PUBLIC_LEFT_IP}:./
ssh -i ${PRIVATE_KEY_PATH} ubuntu@${PUBLIC_LEFT_IP} 'sudo mv /home/ubuntu/ipsec.* /etc/ && sudo ipsec restart'
