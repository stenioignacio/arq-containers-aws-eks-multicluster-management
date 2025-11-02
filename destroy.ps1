# PowerShell script equivalent to destroy.sh

# Control-plane Destroy
Set-Location -Path "control-plane"

Remove-Item -Recurse -Force .terraform -ErrorAction SilentlyContinue

terraform init -reconfigure -upgrade  --backend-config=environment/prd/backend.tfvars

terraform destroy -var-file="environment/prd/terraform.tfvars" --auto-approve

# Clusters Destroy
Set-Location -Path "../clusters"

Write-Host "Destroy do Cluster 01"

Remove-Item -Recurse -Force .terraform -ErrorAction SilentlyContinue

terraform init -reconfigure -upgrade  --backend-config=environment/prd/cluster-01/backend.tfvars 

terraform destroy -var-file="environment/prd/cluster-01/terraform.tfvars" --auto-approve

Write-Host "Destroy do Cluster 02"

Remove-Item -Recurse -Force .terraform -ErrorAction SilentlyContinue

terraform init -reconfigure -upgrade  --backend-config=environment/prd/cluster-02/backend.tfvars

terraform destroy -var-file="environment/prd/cluster-02/terraform.tfvars" --auto-approve

# Ingress Destroy
Set-Location -Path "../ingress"

Write-Host "Destroy do Ingress"

Remove-Item -Recurse -Force .terraform -ErrorAction SilentlyContinue

terraform init -reconfigure -upgrade  --backend-config=environment/prd/backend.tfvars

terraform destroy -var-file="environment/prd/terraform.tfvars" --auto-approve

cd ..