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
}
