

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TSTATE_FILE="${DIR}/../terraform.tfstate"
AWS_TSTATE_FILE="${DIR}/../../../aws/terraform/terraform.tfstate"

ANOTHER_SITE_CIDR=$(terraform state show -state=${AWS_TSTATE_FILE} aws_subnet.PcfVpcPublicSubnet_az1 | grep cidr_block | awk '{print $3}')
ANOTHER_SITE_GATEWAY_IP=$(terraform state show -state=${AWS_TSTATE_FILE} module.vpn.aws_eip.vpn_ip | grep public_ip | awk '{print $3}')

RESOURCE_GROUP=$(terraform state show -state=${TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep name | awk '{print $3}' )
NETWORK=$(terraform state show -state ${TSTATE_FILE} azurerm_virtual_network.pcf_virtual_network | grep name | head -n 1 | awk '{print $3}')
ERT_SUBNET=$(terraform state show -state ${TSTATE_FILE} azurerm_subnet.ert_subnet | grep name | head -n 1 | awk '{print $3}')
ROUTE_TABLE_ID=$(terraform state show -state ${TSTATE_FILE} module.vpn.azurerm_route_table.nat_ert | grep id | awk '{print $3}')
ROUTE_DIRECT_ID=$(terraform state show -state ${TSTATE_FILE} module.vpn.azurerm_route_table.direct_ert | grep id | awk '{print $3}')



terraform apply -state ${TSTATE_FILE} \
          -var another_site_cidr=${ANOTHER_SITE_CIDR} \
          -var another_site_gateway_ip=${ANOTHER_SITE_GATEWAY_IP}

azure network vnet subnet set -n ${ERT_SUBNET} \
              --resource-group ${RESOURCE_GROUP} \
              --vnet-name ${NETWORK} \
              --route-table-id ${ROUTE_DIRECT_ID}


# azure network application-gateway create -n test_application_gateway \
#               --resource-group ${RESOURCE_GROUP} \
#               --vnet-name ${NETWORK} \
#               -d
