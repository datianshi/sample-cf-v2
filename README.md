## Minimal Cloud Foundry deployment


### Purpose

1. Explore bosh v2 schema manifest
2. Explore bosh cli v2
3. Use bosh consumer/producer link as much as possible
4. Using mutual ssl to secure cloud foundry components communication

### Steps

* Create IAAS (gcp/azure/aws).

```
cd ${IAAS}/terraform
terraform apply
./setup_jumpbox.sh
```

* ssh into the jumpbox (Optional: to save the bandwidth) to create director.yml

```
cd sample-cf-v2
${IAAS}/terraform/generate_director_yml.sh
./create_bosh.sh ${IAAS}
```

* Update the cloud config

```
configure ${IAAS}/reserved_range.yml
configure ${IAAS}/cloud_config_ops.yml
./create_cloud_config.sh ${IAAS}
```

* upload stemcell and releases

```
./upload_stemcell_release ${IAAS}
```

* Deploy Cloud Foundry

```
./create-cf.sh ${IAAS}
```

* Configure load balancer wildcard DNS record
