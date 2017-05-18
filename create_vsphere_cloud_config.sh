
CIDR=$(bosh-cli int vsphere/director.yml --path /internal_cidr)
GW=$(bosh-cli int vsphere/director.yml --path /internal_gw)
NETWORK=$(bosh-cli int vsphere/director.yml --path /network_name)
VCENTER_CLUSTER=$(bosh-cli int vsphere/director.yml --path /vcenter_cluster)

director=$(bosh-cli int vsphere/director.yml --path /internal_ip)
director_name=$(bosh-cli int vsphere/director.yml --path /director_name)

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh-cli int vsphere/creds.yml --path /admin_password)

bosh-cli -n -e https://${director}:25555 alias-env ${director_name} \
  --ca-cert <(bosh-cli int vsphere/creds.yml --path /default_ca/ca)

bosh-cli -n -e ${director_name} update-cloud-config vsphere/cloud-config.yml \
  -o vsphere/reserved_range.yml \
  -v internal_cidr=${CIDR} \
  -v internal_gw=${GW} \
  -v vcenter_cluster=${VCENTER_CLUSTER} \
  -v network_name="${NETWORK}" \
  --vars-file config.yml \
  --ca-cert <(bosh-cli int vsphere/creds.yml --path /default_ca/ca)
