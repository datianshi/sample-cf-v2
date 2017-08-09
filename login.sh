#!/bin/bash
#set -e

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh-cli int vsphere/creds.yml --path /admin_password)
