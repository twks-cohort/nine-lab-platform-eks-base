output "cloudwatch_log_group_arn" {
  value = module.eks.cloudwatch_log_group_arn
}

output "cloudwatch_log_group_name" {
  value = module.eks.cloudwatch_log_group_name
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

# Nested attribute containing certificate-authority-data for your cluster.
# This is the base64 encoded certificate data required to communicate with your cluster.
output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "cluster_iam_role_name" {
  value = module.eks.cluster_iam_role_name
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

# The cluster primary security group ID created by the EKS cluster on 1.14 or later.
# Referred to as 'Cluster security group' in the EKS console.
output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

# Security group ID attached to the EKS cluster.
# On 1.14 or later, this is the 'Additional security groups' in the EKS console.
output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "cluster_version" {
  value = module.eks.cluster_version
}

# A kubernetes configuration to authenticate to this EKS cluster.
output "config_map_aws_auth" {
  value = module.eks.config_map_aws_auth
}

output "fargate_iam_role_arn" {
  value = module.eks.fargate_iam_role_arn
}

output "fargate_iam_role_name" {
  value = module.eks.fargate_iam_role_name
}

output "fargate_profile_arns" {
  value = module.eks.fargate_profile_arns
}

# EKS Cluster name and EKS Fargate Profile names separated by a colon (:).
output "fargate_profile_ids" {
  value = module.eks.fargate_profile_ids
}

# kubectl config file contents for this EKS cluster. Will block on cluster creation until the cluster is really ready.
output "kubeconfig" {
  value = module.eks.kubeconfig
  sensitive = true
}

# The filename of the generated kubectl config. Will block on cluster creation until the cluster is really ready.
output "kubeconfig_filename" {
  value = module.eks.kubeconfig_filename
}

# Outputs from EKS node groups. Map of maps, keyed by var.node_groups keys

output "node_groups" {
  value = module.eks.node_groups
}

# The ARN of the OIDC Provider if enable_irsa = true.
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

# Security group rule responsible for allowing pods to communicate with the EKS cluster API.
output "security_group_rule_cluster_https_worker_ingress" {
  value = module.eks.security_group_rule_cluster_https_worker_ingress
}

output "worker_iam_instance_profile_arns" {
  value = module.eks.worker_iam_instance_profile_arns
}

output "worker_iam_instance_profile_names" {
  value = module.eks.worker_iam_instance_profile_names
}

output "worker_iam_role_arn" {
  value = module.eks.worker_iam_role_arn
}

output "worker_iam_role_name" {
  value = module.eks.worker_iam_role_name
}

output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
}

# IDs of the autoscaling groups containing workers.

output "workers_asg_arns" {
  value = module.eks.workers_asg_arns
}

output "workers_asg_names" {
  value = module.eks.workers_asg_names
}

output "workers_default_ami_id" {
  value = module.eks.workers_default_ami_id
}

output "workers_default_ami_id_windows" {
  value = module.eks.workers_default_ami_id_windows
}

output "workers_launch_template_arns" {
  value = module.eks.workers_launch_template_arns
}

output "workers_launch_template_ids" {
  value = module.eks.workers_launch_template_ids
}

output "workers_launch_template_latest_versions" {
  value = module.eks.workers_launch_template_latest_versions
}
