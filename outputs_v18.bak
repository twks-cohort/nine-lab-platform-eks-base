
output "cluster_vpc" {
  value = data.aws_vpc.cluster_vpc.id
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "cloudwatch_log_group_arn" {
  value = module.eks.cloudwatch_log_group_arn
}

output "cloudwatch_log_group_name" {
  value = module.eks.cloudwatch_log_group_name
}

output "cluster_addons" {
  value = module.eks.cluster_addons
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

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

output "cluster_iam_role_unique_id" {
  value = module.eks.cluster_iam_role_unique_id
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_identity_providers" {
  value = module.eks.cluster_identity_providers
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_platform_version" {
  value = module.eks.cluster_platform_version
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

output "cluster_status" {
  value = module.eks.cluster_status
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "eks_managed_node_groups" {
  value = module.eks.eks_managed_node_groups
}

output "eks_managed_node_groups_autoscaling_group_names" {
  value = module.eks.eks_managed_node_groups_autoscaling_group_names
}

output "fargate_profiles" {
  value = module.eks.fargate_profiles
}

output "node_security_group_arn" {
  value = module.eks.node_security_group_arn
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "oidc_provider" {
  value = module.eks.oidc_provider
}

# The ARN of the OIDC Provider if enable_irsa = true.
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "self_managed_node_groups" {
  value = module.eks.self_managed_node_groups
}

output "self_managed_node_groups_autoscaling_group_names" {
  value = module.eks.self_managed_node_groups_autoscaling_group_names
}

output "kubeconfig" {
  value = data.template_file.kubeconfig.rendered
  sensitive = true
}
