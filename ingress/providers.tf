provider "aws" {
  region = var.project_region
  profile = "lab-iam"
  
  default_tags {
    tags = {
      "project" = "eks-multicluster-argocd"
    }
  }
}