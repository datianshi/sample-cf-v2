bosh-cli create-env bosh-deployment/bosh.yml \
  --state ./state.json \
  -o bosh-deployment/vsphere/cpi.yml \
  --vars-store vsphere/creds.yml \
  --vars-file vsphere/director.yml
