#!/bin/bash

cd ingress/

echo "Setup do Ingress"

rm -rf  .terraform

terraform init 

terraform apply -var-file=environment/prd/terraform.tfvars --auto-approve

cd ../clusters


###
echo "Setup do Cluster 01"

rm -rf  .terraform

terraform init

terraform apply -var-file=environment/prd/cluster-01/terraform.tfvars --auto-approve


###
echo "Setup do Cluster 02"

rm -rf  .terraform

terraform init

terraform apply -var-file=environment/prd/cluster-02/terraform.tfvars --auto-approve


cd ../control-plane

rm -rf  .terraform

terraform init 

terraform apply -var-file=environment/prd/terraform.tfvars --auto-approve