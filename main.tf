provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = data.aws_vpc.cluster_vpc.id
  subnets         = data.aws_subnets.private.ids

  enable_irsa                                  = true
  kubeconfig_api_version                       = "client.authentication.k8s.io/v1beta1"
  kubeconfig_aws_authenticator_command         = "aws"
  kubeconfig_aws_authenticator_command_args    = ["eks","get-token","--cluster-name",var.cluster_name]
  kubeconfig_aws_authenticator_additional_args = ["--role", local.authentication_role, "--region=${var.aws_region}"]
  kubeconfig_name                              = "nine-lab-${var.cluster_name}"

  cluster_enabled_log_types     = var.cluster_enabled_log_types
  cluster_log_retention_in_days = var.cluster_log_retention
  cluster_encryption_config     = [
    {
      provider_key_arn = aws_kms_key.cluster_encyption_key.arn
      resources        = ["secrets"]
    }
  ]

  node_groups_defaults = {
    ami_type              = var.default_node_group_ami_type
    platform              = var.default_node_group_platform
    disk_size             = var.default_node_group_disk_size
    force_update_version  = true
    enable_monitoring     = true
  }

  node_groups = {

    "${var.default_node_group_name}" = {
      capacity_type     = var.default_node_group_capacity_type
      desired_capacity  = var.default_node_group_desired_size
      max_capacity      = var.default_node_group_max_size
      min_capacity      = var.default_node_group_min_size
      instance_types    = var.default_node_group_instance_types
      key_name          = ""
      k8s_labels = {
        env = var.cluster_name
      }
    }
  }

}

resource "aws_eks_identity_provider_config" "auth0_oidc_config" {
  cluster_name = var.cluster_name

  oidc {
    client_id                     = var.oidc_client_id
    groups_claim                  = var.oidc_groups_claim
    identity_provider_config_name = var.oidc_identity_provider_config_name
    issuer_url                    = var.oidc_issuer_url
  }

  depends_on = [module.eks]
}

resource "aws_kms_key" "cluster_encyption_key" {
  description             = "Encryption key for kubernetes-secrets envelope encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}
