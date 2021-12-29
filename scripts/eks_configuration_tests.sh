#!/usr/bin/env bash
export CLUSTER=$1
export AWS_ACCOUNT_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .account_id)
export AWS_DEFAULT_REGION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_region)
export AWS_ASSUME_ROLE=$(cat $CLUSTER.auto.tfvars.json | jq -r .assume_role)

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ASSUME_ROLE --role-session-name eks-configuration-test > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

rspec

export DESIRED_VPC_CNI_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .amazon_vpc_cni_version)
export DESIRED_COREDNS_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .coredns_version)
export DESIRED_KUBE_PROXY_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .kube_proxy_version)

bats test