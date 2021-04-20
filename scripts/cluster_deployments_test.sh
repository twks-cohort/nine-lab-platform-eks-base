#!/usr/bin/env bash
export CLUSTER=$1
export AWS_ACCOUNT_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .account_id)
export AWS_DEFAULT_REGION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_region)
aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/DPSTerraformRole --role-session-name awspec-test > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

bats test
