#!/usr/bin/env bash
export CLUSTER=$1
export AWS_DEFAULT_REGION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_region)
export AWS_ASSUME_ROLE=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_assume_role)
export AWS_ACCOUNT_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_account_id)

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ASSUME_ROLE --role-session-name nine-lab-platform-eks-base > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

# terraform-aws-eks module v17 method
cat kubeconfig_$CLUSTER | opw write nine-platform-${CLUSTER} kubeconfig -

# terraform-aws-eks module v18 method
# terraform output kubeconfig | grep -v "EOT" | opw write nine-platform-${CLUSTER} kubeconfig -

# write cluster url and pubic certificate to 1password
terraform output cluster_endpoint | tr -d \\n | sed 's/"//g' | opw write nine-platform-${CLUSTER} cluster-endpoint -
terraform output cluster_certificate_authority_data | tr -d \\n | sed 's/"//g' | opw write nine-platform-${CLUSTER} base64-certificate-authority-data -


# nine-platform-nonprod-us-east-2
# nine-platform-prod-us-east-1
# terraform output DPSNonprodServiceAccount_encrypted_aws_secret_access_key | sed 's/"//g' | base64 -d | gpg -dq --passphrase ${GPG_KEY_PASSPHRASE} |  opw write aws-dps-2 DPSNonprodServiceAccount-aws-secret-access-key -
# terraform output DPSNonprodServiceAccount_aws_access_key_id | tr -d \\n | sed 's/"//g' | opw write aws-dps-2 DPSNonprodServiceAccount-aws-access-key-id -
