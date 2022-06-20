#!/usr/bin/env bash
export CLUSTER=$1
export AWS_DEFAULT_REGION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_region)
export AWS_ASSUME_ROLE=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_assume_role)
export AWS_ACCOUNT_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_account_id)

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ASSUME_ROLE --role-session-name lab-platform-eks-base > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

# terraform-aws-eks module v17 method
cat kubeconfig_$CLUSTER | opw write platform-${CLUSTER} kubeconfig -

# terraform-aws-eks module v18 method
# terraform output kubeconfig | grep -v "EOT" | opw write platform-${CLUSTER} kubeconfig -
