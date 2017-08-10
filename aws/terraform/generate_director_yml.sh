#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIRECTOR_CONFIG="${DIR}/../director.yml"
TSTATE_FILE="${DIR}/terraform.tfstate"

BOSH_CIDR=$(terraform state show -state ${TSTATE_FILE} aws_subnet.PcfVpcInfraSubnet_az1 | grep cidr_block | awk '{print $3}')
BOSH_SUBNET_ID=$(terraform state show -state ${TSTATE_FILE} aws_subnet.PcfVpcInfraSubnet_az1 | grep id | head -n 1 | awk '{print $3}')
SECURITY_GROUP=$(terraform state show -state ${TSTATE_FILE} aws_security_group.directorSG | grep id | head -n 1 | awk '{print $3}')
ERT_CIDR=$(terraform state show -state ${TSTATE_FILE} aws_subnet.PcfVpcPrivateSubnet_az1 | grep cidr_block | awk '{print $3}')
ERT_SUBNET_ID=$(terraform state show -state ${TSTATE_FILE} aws_subnet.PcfVpcPrivateSubnet_az1 | grep id | head -n 1 | awk '{print $3}')

WEB_LOAD_BALANCER=$(terraform state show -state ${TSTATE_FILE} aws_elb.cfrouter | grep name | tail -n 1 | awk '{print $3}')
PROXY_SERVER_IP=$(terraform state show -state ${TSTATE_FILE} aws_instance.jumpbox | grep private_ip | awk '{print $3}')

function indexCidr() {
  INDEX=$(echo ${1} | sed "s/\(.*\)\.\(.*\)\.\(.*\)\..*/\1.\2.\3.${2}/g")
  echo ${INDEX}
}

internal_gw=$(indexCidr ${BOSH_CIDR} 1)
internal_ip=$(indexCidr ${BOSH_CIDR} 6)

ert_internal_gw=$(indexCidr ${ERT_CIDR} 1)


echo "director_name: bosh_aws" > ${DIRECTOR_CONFIG}
echo "internal_cidr: ${BOSH_CIDR}" >>${DIRECTOR_CONFIG}
echo "internal_gw: ${internal_gw}" >> ${DIRECTOR_CONFIG}
echo "internal_ip: ${internal_ip}" >> ${DIRECTOR_CONFIG}
echo "subnet_id: ${BOSH_SUBNET_ID}" >> ${DIRECTOR_CONFIG}
echo "default_security_groups: [${SECURITY_GROUP}]" >> ${DIRECTOR_CONFIG}
echo "ert_internal_cidr: ${ERT_CIDR}" >>${DIRECTOR_CONFIG}
echo "ert_internal_gw: ${ert_internal_gw}" >>${DIRECTOR_CONFIG}
echo "ert_subnet_id: ${ERT_SUBNET_ID}" >> ${DIRECTOR_CONFIG}
echo "region": ${TF_VAR_aws_region} >> ${DIRECTOR_CONFIG}
echo "az": ${TF_VAR_az1} >> ${DIRECTOR_CONFIG}
echo "access_key_id": ${TF_VAR_aws_access_key} >> ${DIRECTOR_CONFIG}
echo "secret_access_key": ${TF_VAR_aws_secret_key} >> ${DIRECTOR_CONFIG}
echo "default_key_name": ${TF_VAR_aws_key_name} >> ${DIRECTOR_CONFIG}
echo "web_load_balancer": ${WEB_LOAD_BALANCER} >> ${DIRECTOR_CONFIG}
echo "private_key": "${DIR}/$(basename $PRIVATE_KEY_PATH)" >> ${DIRECTOR_CONFIG}
echo "proxy_server_ip": ${PROXY_SERVER_IP} >> ${DIRECTOR_CONFIG}
