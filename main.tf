locals {
  authentication_role = "arn:aws:iam::${var.account_id}:role/${var.assume_role}"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  enable_irsa                                  = true
  kubeconfig_aws_authenticator_command         = "aws"
  kubeconfig_aws_authenticator_command_args    = ["eks","get-token","--cluster-name",var.cluster_name]
  kubeconfig_aws_authenticator_additional_args = ["--role", local.authentication_role]

  cluster_enabled_log_types     = var.cluster_enabled_log_types
  cluster_log_retention_in_days = 90
  cluster_encryption_config     = [
    {
      provider_key_arn = aws_kms_key.cluster_encyption_key.arn
      resources        = ["secrets"]
    }
  ]

  vpc_id  = data.aws_vpc.cluster_vpc.id
  subnets = data.aws_subnet_ids.private.ids

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 80
  }
  node_groups = {
    group_a = {
      desired_capacity = var.node_group_a_desired_capacity
      capacity_type    = var.node_group_a_capacity_type
      max_capacity     = var.node_group_a_max_capacity
      min_capacity     = var.node_group_a_min_capacity
      disk_size        = var.node_group_a_disk_size
      instance_types   = var.node_group_a_instance_types
      # set key_name to empty string to disable remote access to workers
      key_name         = ""
      k8s_labels = {
        env = var.cluster_name
      }
      additional_tags = {
        "cluster"  = var.cluster_name
        "pipeline" = "lab-platform-eks-base"
        "k8s.io/cluster-autoscaler/enabled" = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "true"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      }
    }
  }
}

resource "aws_kms_key" "cluster_encyption_key" {
  description             = "Encryption key for kubernetes-secrets envelope encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}
