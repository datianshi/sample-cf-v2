set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TSTATE_FILE="${DIR}/terraform.tfstate"

PUBLIC_IP_ID=$(terraform state show -state=${TSTATE_FILE} azurerm_public_ip.vpn-public-ip | grep id | awk '{print $3}')
RESOURCE_GROUP=$(terraform state show -state=${TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep name | awk '{print $3}' )
LOCATION=$(terraform state show -state=${TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep location | awk '{print $3}' )
NETWORK=$(terraform state show -state ${TSTATE_FILE} azurerm_virtual_network.pcf_virtual_network | grep name | head -n 1 | awk '{print $3}')

azure network vpn-gateway create -n my_vpn_gateway \
      -l ${LOCATION} \
      -y 'PolicyBased' \
      -u ${PUBLIC_IP_ID} \
      -m ${NETWORK} \
      -g ${RESOURCE_GROUP}
