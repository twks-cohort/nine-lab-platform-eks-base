# module "efs_csi_storage" {
#   source = "cloudposse/efs/aws"
#   version     = "0.32.5"

#   name      = "${var.cluster_name}-efs-csi-storage"
#   namespace = "twdps-lab"
#   stage     = var.cluster_name

#   region    = var.aws_region
#   vpc_id    = data.aws_vpc.cluster_vpc.id
#   subnets   = data.aws_subnet_ids.cluster_node_subnets.ids

#   allowed_security_group_ids = [module.eks.cluster_security_group_id]

#   efs_backup_policy_enabled = true
#   encrypted = true

#   tags = {
#     "cluster" = var.cluster_name
#     "pipeline" = "lab-platform-eks-base"
#   }
# }
