export TF_VAR_env_name=sding-azure-cf
export TF_VAR_env_short_name=sding
export TF_VAR_client_id=
export TF_VAR_client_secret=
export TF_VAR_subscription_id=
export TF_VAR_tenant_id=
export TF_VAR_location="West US"
export TF_VAR_priv_ip_mysql_lb=192.168.4.8
export TF_VAR_ops_manager_image_uri=https://opsmanagerwestus.blob.core.windows.net/images/ops-manager-1.10.6.vhd
export TF_VAR_vm_admin_username=ubuntu
export TF_VAR_vm_admin_password=ubuntu
export TF_VAR_vm_admin_public_key=$(cat ~/work/aws/personal/pcf-sding.pub)


export TF_VAR_dns_suffix=shaozhending.com


export TF_VAR_vnet_cidr=192.168.0.0/20
export TF_VAR_subnet_infra_cidr=192.168.0.0/26
export TF_VAR_subnet_infra_reserved=192.168.0.1-192.168.0.9
export TF_VAR_subnet_infra_dns=168.63.129.16,8.8.8.8
export TF_VAR_subnet_infra_gateway=192.168.0.1
export TF_VAR_subnet_ert_cidr=192.168.4.0/22
export TF_VAR_subnet_ert_reserved=192.168.4.1-192.168.4.9
export TF_VAR_subnet_ert_dns=168.63.129.16,8.8.8.8
export TF_VAR_subnet_ert_gateway=192.168.4.1

export PRIVATE_KEY_PATH=/Users/sding/work/aws/personal/pcf-sding.pem
