variable "aws_region" {}
variable "account_id" {
  sensitive = true
}
# once we get more secret storage space, hide the role
variable "assume_role" {
  sensitive = true
}

variable "cluster_name" {}
variable "cluster_version" {}
variable "cluster_enabled_log_types" {
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}
variable "vpc_cni_version" {}
variable "coredns_version" {}
variable "kube_proxy_version" {}
variable "aws_ebs_csi_version" {}

variable "default_node_group_ami_type" {}
variable "default_node_group_platform" {}
variable "default_node_group_min_size" {}
variable "default_node_group_max_size" {}
variable "default_node_group_desired_size" {}
variable "default_node_group_disk_size" {}
variable "default_node_group_capacity_type" {}
variable "default_node_group_instance_types" {}
