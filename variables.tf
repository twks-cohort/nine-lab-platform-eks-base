variable "aws_region" {}
variable "account_id" {}
variable "assume_role" {}

variable "cluster_name" {}
variable "cluster_version" {}
variable "domain" {}
variable "domain_account" {}
variable "cluster_enabled_log_types" {
  default = ["api", "audit", "authenticator"]
}

variable "node_group_a_desired_capacity" {}
variable "node_group_a_max_capacity" {}
variable "node_group_a_min_capacity" {}
variable "node_group_a_disk_size" {}
variable "node_group_a_instance_type" {}
