DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TSTATE_FILE="${DIR}/terraform.tfstate"
AWS_TSTATE_FILE="${DIR}/../../aws/terraform/terraform.tfstate"

RESOURCE_GROUP=$(terraform state show -state=${TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep name | awk '{print $3}' )
LOCATION=$(terraform state show -state=${TSTATE_FILE} azurerm_resource_group.pcf_resource_group | grep location | awk '{print $3}' )
NETWORK=$(terraform state show -state ${TSTATE_FILE} azurerm_virtual_network.pcf_virtual_network | grep name | head -n 1 | awk '{print $3}')
PUBLIC_SUBNET=$(terraform state show -state ${TSTATE_FILE} azurerm_subnet.app_gateway_subnet | grep id | head -n 1 | awk '{print $3}')


azure network application-gateway create -n test_application_gateway \
              --resource-group ${RESOURCE_GROUP} \
              --location ${LOCATION} \
              --vnet-name ${NETWORK} \
              --subnet-id ${PUBLIC_SUBNET} \
              --servers 10.0.17.16 \
              --cert-file certificate.pfx \
              --cert-password shaozhen \
              --http-settings-cookie-based-affinity Enabled \
              --http-settings-protocol Http \
              --frontend-port 443 \
              --http-settings-port 80 \
              --http-settings-cookie-based-affinity Enabled \
              --routing-rule-type Basic
