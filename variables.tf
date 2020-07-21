terraform {
  required_version = "~> 0.12.28"
  required_providers {
    aws = "~> 2.69"
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
  version = "~> 2.0"
  region  = var.aws_region
  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/${var.assume_role}"
    session_name = "lab-platform-eks-sandbox"
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

variable "aws_region" {}
variable "account_id" {}
variable "assume_role" {}

variable "cluster_name" {}
variable "cluster_version" {}
variable "cluster_enabled_log_types" {
  default = ["api", "audit", "authenticator"]
}

variable "node_group_a_desired_capacity" {}
variable "node_group_a_max_capacity" {}
variable "node_group_a_min_capacity" {}
variable "node_group_a_disk_size" {}
variable "node_group_a_instance_type" {}

locals {
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler"
}
