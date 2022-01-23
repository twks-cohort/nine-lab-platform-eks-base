locals {
  authentication_role = "arn:aws:iam::${var.account_id}:role/${var.assume_role}"
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "lab-${var.cluster_name}"
    clusters = [{
      name = module.eks.cluster_id
      cluster = {
        certificate-authority-data = module.eks.cluster_certificate_authority_data
        server                     = module.eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "lab-${var.cluster_name}"
      context = {
        cluster = module.eks.cluster_id
        user    = "lab-${var.cluster_name}"
      }
    }]
    users = [{
      name = "lab-${var.cluster_name}"
      user = {
        exec = {
          apiVersion = "client.authentication.k8s.io/v1alpha1"
          command    = "aws"
          args = [
            "eks", "get-token","--cluster-name", var.cluster_name, "--role", local.authentication_role
          ]
        }
      }
    }]
  })
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.2.0"
  create  = true

  cluster_name                = var.cluster_name
  cluster_version             = var.cluster_version
  vpc_id                      = data.aws_vpc.cluster_vpc.id
  subnet_ids                  = data.aws_subnet_ids.private.ids
  cluster_ip_family           = "ipv4"
  create_cni_ipv6_iam_policy  = false
  enable_irsa                 = true

  create_cluster_security_group           = true
  cluster_enabled_log_types               = var.cluster_enabled_log_types

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.cluster_encyption_key.arn
      resources        = ["secrets"]
    }
  ]

  eks_managed_node_group_defaults = {
    ami_type              = var.default_node_group_ami_type
    platform              = var.default_node_group_platform
    disk_size             = var.default_node_group_disk_size
    instance_types        = var.default_node_group_instance_types
    force_update_version  = true
    enable_monitoring     = true
  }

  eks_managed_node_groups = {
    group_a = {
      capacity_type              = var.default_node_group_capacity_type
      desired_size               = var.default_node_group_desired_size
      max_size                   = var.default_node_group_max_size
      min_size                   = var.default_node_group_min_size
      instance_types             = var.default_node_group_instance_types
    }
  }

  cluster_addons = {
    coredns    = {
      addon_version     = var.coredns_version
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      addon_version     = var.kube_proxy_version
    }
    vpc-cni    = {
      addon_version     = var.vpc_cni_version
      resolve_conflicts = "OVERWRITE"
    }
  }

  tags = {
    "cluster"  = var.cluster_name
    "pipeline" = "lab-platform-eks-base"
  }
}

resource "aws_kms_key" "cluster_encyption_key" {
  description             = "Encryption key for kubernetes-secrets envelope encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}
