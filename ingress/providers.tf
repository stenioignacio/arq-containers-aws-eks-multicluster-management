provider "aws" {
  region = var.project_region
  profile = "lab"
  
  default_tags {
    tags = {
      "project" = "eks-multicluster-argocd"
    }
  }
}