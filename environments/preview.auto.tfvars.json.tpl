{
    "aws_region": "us-east-2",
    "assume_role": "DPSTerraformRole",
    "account_id": "{{ twdps/di/svc/aws/dps-2/aws-account-id }}",

    "cluster_name": "preview",
    "cluster_version": "1.21",
    "create_vpc_cni_role": true,
    "vpc_cni_version": "v1.10.1-eksbuild.1",
    "coredns_version": "v1.8.4-eksbuild.1",
    "kube_proxy_version": "v1.21.2-eksbuild.2",
    "aws_ebs_csi_version": "v1.4.0-eksbuild.preview",
    "create_aws_ebs_csi_role": true,

    "node_group_a_desired_capacity": "3",
    "node_group_a_capacity_type": "ON_DEMAND",
    "node_group_a_max_capacity": "5",
    "node_group_a_min_capacity": "3",
    "node_group_a_disk_size": "80",
    "node_group_a_instance_types": ["m5.xlarge"]
}

