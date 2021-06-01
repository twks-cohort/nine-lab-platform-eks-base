{
    "aws_region": "us-east-2",
    "assume_role": "DPSTerraformRole",
    "account_id": "{{ twdps/di/svc/aws/dps-2/aws-account-id }}",

    "cluster_name": "preview",
    "cluster_version": "1.19",
    "domain": "twdps.io",
    "domain_account": "{{ twdps/di/svc/aws/dps-1/aws-account-id }}",

    "node_group_a_desired_capacity": "3",
    "node_group_a_capacity_type": "ON_DEMAND",
    "node_group_a_max_capacity": "5",
    "node_group_a_min_capacity": "3",
    "node_group_a_disk_size": "80",
    "node_group_a_instance_types": ["m5.xlarge"]
}
