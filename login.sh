#!/bin/bash
#set -e

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=$(bosh-cli int aws/creds.yml --path /admin_password)
