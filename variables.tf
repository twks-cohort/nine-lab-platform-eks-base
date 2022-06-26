variable "aws_region" {}
variable "aws_account_id" {
  sensitive = true
}

variable "aws_assume_role" {
  sensitive = true
}

variable "cluster_name" {}
variable "cluster_version" {}
variable "cluster_enabled_log_types" {}
variable "cluster_log_retention" {}
variable "vpc_cni_version" {}
variable "coredns_version" {}
variable "kube_proxy_version" {}
variable "aws_ebs_csi_version" {}
variable "alert_channel" {}

variable "default_node_group_name" {}
variable "default_node_group_ami_type" {}
variable "default_node_group_platform" {}
variable "default_node_group_min_size" {}
variable "default_node_group_max_size" {}
variable "default_node_group_desired_size" {}
variable "default_node_group_disk_size" {}
variable "default_node_group_capacity_type" {}
variable "default_node_group_instance_types" {}

# variable "oidc_client_id" {}
# variable "oidc_groups_claim" {}
# variable "oidc_identity_provider_config_name" {}
# variable "oidc_issuer_url" {}
