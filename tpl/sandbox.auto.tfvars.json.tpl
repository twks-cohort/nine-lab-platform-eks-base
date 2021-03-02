{
    "aws_region": "us-east-2",
    "assume_role": "DPSTerraformRole",
    "account_id": "{{ twdps/di/svc/aws/dps-2/aws-account-id }}",

    "cluster_name": "sandbox",
    "domain": "twdps.io",
    "domain_account": "{{ twdps/di/svc/aws/dps-1/aws-account-id }}",
    "cluster_version": "1.19",
    "cert_manager_version": "1.2.0",
    "cert_manager_issuer_endpoint": "https://acme-v02.api.letsencrypt.org/directory",
    "cert_manager_issuer_email": "twdps.io@gmail.com",
    "node_group_a_desired_capacity": "1",
    "node_group_a_max_capacity": "3",
    "node_group_a_min_capacity": "1",
    "node_group_a_disk_size": "80",
    "node_group_a_instance_type": "m5.xlarge"
}
