#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIRECTOR_CONFIG="${DIR}/../director.yml"
TSTATE_FILE="${DIR}/terraform.tfstate"
ACCOUNT_FILE="${DIR}/account.json"

BOSH_NETWORK_NAME=$(terraform state show -state ${TSTATE_FILE} google_compute_network.bosh | grep name | awk '{print $3}')
BOSH_CIDR=$(terraform state show -state ${TSTATE_FILE} google_compute_subnetwork.bosh-subnet-1 | grep ip_cidr_range | awk '{print $3}')
BOSH_SUBNET_NAME=$(terraform state show -state ${TSTATE_FILE} google_compute_subnetwork.bosh-subnet-1 | grep name | awk '{print $3}')
ERT_CIDR=$(terraform state show -state ${TSTATE_FILE} google_compute_subnetwork.cf-private-subnet-1 | grep ip_cidr_range | awk '{print $3}')
ERT_SUBNET_NAME=$(terraform state show -state ${TSTATE_FILE} google_compute_subnetwork.cf-private-subnet-1 | grep name | awk '{print $3}')
CF_PUBLIC_TARGET_POOL=$(terraform state show -state ${TSTATE_FILE} google_compute_target_pool.cf-public | grep name | awk '{print $3}')
JSON_KEY=$(cat ${ACCOUNT_FILE} | sed 's/^\(.*\)$/  \1/g')

# WEB_LOAD_BALANCER=$(terraform state show -state ${TSTATE_FILE} aws_elb.cfrouter | grep name | tail -n 1 | awk '{print $3}')

function indexCidr() {
  INDEX=$(echo ${1} | sed "s/\(.*\)\.\(.*\)\.\(.*\)\..*/\1.\2.\3.${2}/g")
  echo ${INDEX}
}

internal_gw=$(indexCidr ${BOSH_CIDR} 1)
internal_ip=$(indexCidr ${BOSH_CIDR} 6)

ert_internal_gw=$(indexCidr ${ERT_CIDR} 1)


echo "director_name: bosh_gcp" > ${DIRECTOR_CONFIG}
echo "network: ${BOSH_NETWORK_NAME}" >> ${DIRECTOR_CONFIG}
echo "internal_cidr: ${BOSH_CIDR}" >>${DIRECTOR_CONFIG}
echo "internal_gw: ${internal_gw}" >> ${DIRECTOR_CONFIG}
echo "internal_ip: ${internal_ip}" >> ${DIRECTOR_CONFIG}
echo "subnetwork: ${BOSH_SUBNET_NAME}" >> ${DIRECTOR_CONFIG}


echo "ert_internal_cidr: ${ERT_CIDR}" >>${DIRECTOR_CONFIG}
echo "ert_internal_gw: ${ert_internal_gw}" >>${DIRECTOR_CONFIG}
echo "ert_subnetwork: ${ERT_SUBNET_NAME}" >> ${DIRECTOR_CONFIG}

echo "zone": ${TF_VAR_zone} >> ${DIRECTOR_CONFIG}
echo "project_id": ${TF_VAR_projectid} >> ${DIRECTOR_CONFIG}
echo -e "gcp_credentials_json: |" >> ${DIRECTOR_CONFIG}
echo "${JSON_KEY}" >> ${DIRECTOR_CONFIG}
echo -e "tags: \n- internal\n- no-ip" >> ${DIRECTOR_CONFIG}
echo -e "ert_tags: \n- internal\n- no-ip" >> ${DIRECTOR_CONFIG}
echo -e "cf_public_target_pool: ${CF_PUBLIC_TARGET_POOL}" >> ${DIRECTOR_CONFIG}
echo -e "cf_public_firewall_tag: cf-public" >> ${DIRECTOR_CONFIG}
