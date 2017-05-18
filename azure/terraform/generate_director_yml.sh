#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIRECTOR_CONFIG="${DIR}/../director.yml"
TSTATE_FILE="${DIR}/terraform.tfstate"

BOSH_CIDR=$(terraform state show -state ${TSTATE_FILE} azurerm_subnet.opsman_and_director_subnet | grep address_prefix | awk '{print $3}')
NETWORK=$(terraform state show -state ${TSTATE_FILE} azurerm_virtual_network.pcf_virtual_network | grep name | head -n 1 | awk '{print $3}')
SUBNET=$(terraform state show -state ${TSTATE_FILE} azurerm_subnet.opsman_and_director_subnet | grep name | head -n 1 | awk '{print $3}')
RESOURCE_GROUP=$(terraform state show -state ${TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep name | awk '{print $3}')
STORAGE_ACCOUNT_NAME=$(terraform state show -state ${TSTATE_FILE} azurerm_storage_account.bosh_root_storage_account | grep name | head -n 1 | awk '{print $3}')
SECURITY_GROUP=$(terraform state show -state ${TSTATE_FILE} azurerm_network_security_group.cf_security_group | grep name | head -n 1 | awk '{print $3}')
ERT_CIDR=$(terraform state show -state ${TSTATE_FILE} azurerm_subnet.ert_subnet | grep address_prefix | awk '{print $3}')
ERT_SUBNET_NAME=$(terraform state show -state ${TSTATE_FILE} azurerm_subnet.ert_subnet | grep name | head -n 1 | awk '{print $3}')
VM_STORAGE=$(terraform state show -state ${TSTATE_FILE} azurerm_storage_account.bosh_vms_storage_account_1 | grep name | head -n 1 | awk '{print $3}')

vm_storage="*${VM_STORAGE::-1}*"

function indexCidr() {
  INDEX=$(echo ${1} | sed "s/\(.*\)\.\(.*\)\.\(.*\)\..*/\1.\2.\3.${2}/g")
  echo ${INDEX}
}

internal_gw=$(indexCidr ${BOSH_CIDR} 1)
internal_ip=$(indexCidr ${BOSH_CIDR} 6)

ert_internal_gw=$(indexCidr ${ERT_CIDR} 1)


echo "director_name: bosh_azure" > ${DIRECTOR_CONFIG}
echo "internal_cidr: ${BOSH_CIDR}" >>${DIRECTOR_CONFIG}
echo "internal_gw: ${internal_gw}" >> ${DIRECTOR_CONFIG}
echo "internal_ip: ${internal_ip}" >> ${DIRECTOR_CONFIG}
echo "vnet_name: ${NETWORK}" >> ${DIRECTOR_CONFIG}
echo "subnet_name: ${SUBNET}" >> ${DIRECTOR_CONFIG}
echo "subscription_id: ${TF_VAR_subscription_id}" >> ${DIRECTOR_CONFIG}
echo "tenant_id: ${TF_VAR_tenant_id}" >> ${DIRECTOR_CONFIG}
echo "client_id: ${TF_VAR_client_id}" >> ${DIRECTOR_CONFIG}
echo "client_secret: ${TF_VAR_client_secret}" >> ${DIRECTOR_CONFIG}
echo "resource_group_name: ${RESOURCE_GROUP}" >> ${DIRECTOR_CONFIG}
echo "storage_account_name: ${STORAGE_ACCOUNT_NAME}" >> ${DIRECTOR_CONFIG}
echo "security_group: ${SECURITY_GROUP}" >> ${DIRECTOR_CONFIG}
echo "ert_internal_cidr: ${ERT_CIDR}" >>${DIRECTOR_CONFIG}
echo "ert_internal_gw: ${ert_internal_gw}" >>${DIRECTOR_CONFIG}
echo "ert_subnet_name: ${ERT_SUBNET_NAME}" >> ${DIRECTOR_CONFIG}
echo "vm_storage_account_name: ${vm_storage}" >> ${DIRECTOR_CONFIG}
