{
    "aws_region": "us-east-2",
    "assume_role": "DPSTerraformRole",
    "account_id": "{{ twdps/di/svc/aws/dps-2/aws-account-id }}",

    "cluster_name": "preview",
    "create_aws_node_role": false,
    "cluster_version": "1.21",
    "amazon_vpc_cni_version": "v1.10.1-eksbuild.1",
    "coredns_version": "v1.8.4-eksbuild.1",
    "kube_proxy_version": "v1.21.2-eksbuild.2",

    "node_group_a_desired_capacity": "3",
    "node_group_a_capacity_type": "ON_DEMAND",
    "node_group_a_max_capacity": "5",
    "node_group_a_min_capacity": "3",
    "node_group_a_disk_size": "80",
    "node_group_a_instance_types": ["m5.xlarge"]
}
