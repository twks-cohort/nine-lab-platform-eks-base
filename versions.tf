terraform {
  required_version = "~> 0.15.3"
  required_providers {
    aws        = ">= 3.40"
    local      = ">= 1.4"
    random     = ">= 2.1"
    kubernetes = ">= 1.11"
    http = {
      source  = "terraform-aws-modules/http"
      version = ">= 2.3"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "twdps"
    workspaces {
      prefix = "lab-platform-eks-"
    }
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/${var.assume_role}"
    session_name = "lab-platform-eks"
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
