module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "13.1.0"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  cluster_enabled_log_types = var.cluster_enabled_log_types
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.cluster_encyption_key.arn
      resources        = ["secrets"]
    }
  ]
  
  enable_irsa  = true
  vpc_id       = data.aws_vpc.cluster_vpc.id
  subnets      = data.aws_subnet_ids.private.ids
  
  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 80
  }
  node_groups = {
    side_a = {
      desired_capacity = var.node_group_a_desired_capacity
      max_capacity     = var.node_group_a_max_capacity
      min_capacity     = var.node_group_a_min_capacity
      disk_size        = var.node_group_a_disk_size
      instance_type    = var.node_group_a_instance_type
      k8s_labels = {
        Environment = var.cluster_name
      }
      additional_tags = {
        "cluster" = var.cluster_name
        "pipeline" = "lab-platform-eks"
      }
    }
  }
  kubeconfig_aws_authenticator_command = "aws"
  wait_for_cluster_cmd = "until curl -k -s $ENDPOINT/healthz >/dev/null; do sleep 4; done"
}

resource "aws_route53_zone" "cluster_subdomain_zone" {
  name = "${var.cluster_name}.${var.domain}"
  tags = {
    cluster     = var.cluster_name
    cluster_domain   = "${var.cluster_name}.${var.domain}"
    pipeline    = "lab-platform-eks"
  }
}

resource "aws_kms_key" "cluster_encyption_key" {
  description = "Encryption key for kubernetes-secrets envelope encryption"
  enable_key_rotation = true
  deletion_window_in_days = 7
}

#############
# RDS Aurora
#############
module "aurora" {
  source                = "terraform-aws-modules/rds-aurora/aws"
  name                  = var.cluster_name
  engine                = "aurora-postgresql"
  engine_mode           = "serverless"
  engine_version        = "10.12"
  replica_scale_enabled = false
  replica_count         = 0
  database_name         = "root"
  backtrack_window = 10 # ignored in serverless

  subnets                         = data.aws_subnet_ids.private.ids
  vpc_id                          = data.aws_vpc.cluster_vpc.id
  monitoring_interval             = 60
  instance_type                   = "db.r4.large"
  apply_immediately               = true
  skip_final_snapshot             = true
  storage_encrypted               = true
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_postgresql10parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_postgresql10parameter_group.id

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 4
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "aurora_db_postgresql10parameter_group" {
  name        = "${var.cluster_name}-aurora1012-parameter-group"
  family      = "aurora-postgresql10"
  description = "${var.cluster_name}-aurora-postgresql10-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgresql10parameter_group" {
  name        = "${var.cluster_name}-1012-cluster-parameter-group"
  family      = "aurora-postgresql10"
  description = "${var.cluster_name}-aurora-postgresql10-cluster-parameter-group"
}

resource "aws_security_group_rule" "allow_access" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.aurora.this_security_group_id
}