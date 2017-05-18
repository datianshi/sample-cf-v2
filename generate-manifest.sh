
director_name=$(bosh-cli int vsphere/director.yml --path /director_name)
director=$(bosh-cli int vsphere/director.yml --path /internal_ip)



export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh-cli int vsphere/creds.yml --path /admin_password)

bosh-cli -n -e https://${director}:25555 alias-env ${director_name} \
  --ca-cert <(bosh-cli int vsphere/creds.yml --path /default_ca/ca)

DIRECTOR_UUID=$(bosh-cli -e custom-bosh environment --json | jq -r '.Tables[].Rows[] | select(.[0] == "UUID") | .[1]')

bosh-cli int cloudfoundry.yml --vars-store creds.yml \
            -o common/network_jobs.yml \
            -v director_uuid=${DIRECTOR_UUID} \
            --vars-file config.yml > cf.yml

bosh-cli -n -e ${director_name} -d cf deploy cf.yml
