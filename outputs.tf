# # terraform-aws-eks module outputs

# Formatted yaml output for base aws-auth configmap containing roles used in cluster node groups/fargate profiles
output "aws_auth_configmap_yaml" {
  value = module.eks.aws_auth_configmap_yaml
}	

output "cloudwatch_log_group_arn" {
  value = module.eks.cloudwatch_log_group_arn
}

output "cloudwatch_log_group_name" {
  value = module.eks.cloudwatch_log_group_name
}

# Map of attribute maps for all EKS cluster addons enabled
output "cluster_addons" {
  value = module.eks.cluster_addons
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

# Base64 encoded certificate data required to communicate with the cluster
output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

# Endpoint for your Kubernetes API server
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

# Map of attribute maps for all EKS identity providers enabled
output "cluster_identity_providers" {
  value = module.eks.cluster_identity_providers
}

# The URL on the EKS cluster for the OpenID Connect identity provider
output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "cluster_platform_version" {
  value = module.eks.cluster_platform_version
}

# Cluster security group that was created by Amazon EKS for the cluster.
# Managed node groups use this security group for control-plane-to-data-plane communication.
# Referred to as 'Cluster security group' in the EKS console
output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "cluster_security_group_arn" {
  value = module.eks.cluster_security_group_arn
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

# Status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED
output "cluster_status" {
  value = module.eks.cluster_status
}

# Map of attribute maps for all EKS managed node groups created
output "eks_managed_node_groups" {
  value = module.eks.eks_managed_node_groups
}

# Map of attribute maps for all EKS Fargate Profiles created
output "fargate_profiles" {
  value = module.eks.fargate_profiles
}

output "node_security_group_arn" {
  value = module.eks.node_security_group_arn
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

# The ARN of the OIDC Provider if enable_irsa = true
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "self_managed_node_groups" {
  value = module.eks.self_managed_node_groups
}

output "kubectl_config" {
  value       = local.kubeconfig
  sensitive   = true
}
