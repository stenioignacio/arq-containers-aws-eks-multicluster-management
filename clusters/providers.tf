provider "aws" {
  region = var.project_region
  profile = "lab"

  default_tags {
    tags = {
      "project" = "eks-multicluster-argocd"
    }
  }
}

terraform {
  required_providers {
    kubectl ={
      source = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  host = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.default.token
}

provider "helm" {
  kubernetes = {
    host = aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority.0.data)
    token = data.aws_eks_cluster_auth.default.token
  }
}

provider "kubectl" {
  host = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.default.token
}