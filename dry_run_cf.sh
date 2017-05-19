
#!/bin/bash
set -e

source lib/common.sh
iaas=$1
check_argument ${iaas}


bosh-cli int cloudfoundry.yml --vars-store creds.yml \
            -o common/network_jobs.yml \
            -o ${iaas}/cf_vm_extensions.yml \
            -v director_uuid=XXXX \
            --vars-file config.yml
