set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TSTATE_FILE="${DIR}/terraform.tfstate"

SHARED_SECRET=abcdefgh
LOCAL_GATEWAY_NAME=$(terraform state show -state=${TSTATE_FILE} module.vpn.azurerm_local_network_gateway.onpremise | grep name | head -n 1 | awk '{print $3}' )
RESOURCE_GROUP=$(terraform state show -state=${TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep name | awk '{print $3}' )
LOCATION=$(terraform state show -state=${TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep location | awk '{print $3}' )

azure network vpn-connection create -n my_vpn_connection \
              -l ${LOCATION} \
              -i my_vpn_gateway \
              -d ${LOCAL_GATEWAY_NAME} \
              -y IPsec \
              -k ${SHARED_SECRET} \
              -g ${RESOURCE_GROUP}
