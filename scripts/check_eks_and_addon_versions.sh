#!/usr/bin/env bash

# TODO: A webhook exist for having the notices below post to the lab-nonprod-alerts channel.
# However, we've run out of secret space in our free tier secrethub account and have not yet
# been given access to the 1password api, etc.

export CLUSTER=$1
export REGION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_region)
export AWS_ASSUME_ROLE=$(cat $CLUSTER.auto.tfvars.json | jq -r .assume_role)
export AWS_ACCOUNT_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .account_id)

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ASSUME_ROLE --role-session-name eks-configuration-test > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

export DESIRED_CLUSTER_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .cluster_version)
export DESIRED_VPC_CNI_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .amazon_vpc_cni_version)
export DESIRED_COREDNS_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .coredns_version)
export DESIRED_KUBE_PROXY_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .kube_proxy_version)

export CLUSTER_NODES=$(aws-vault exec tf.dps2 -- aws ec2 describe-instances --filter "Name=tag:kubernetes.io/cluster/$CLUSTER,Values=owned")
export CURRENT_AMI_VERSION=$(echo $CLUSTER_NODES | jq -r '.Reservations | .[0] | .Instances | .[0] | .ImageId')
export LATEST_AMI_VERSION=$(aws-vault exec tf.dps2 -- aws ssm get-parameter --name /aws/service/eks/optimized-ami/$DESIRED_CLUSTER_VERSION/amazon-linux-2/recommended/image_id --region $REGION | jq -r '.Parameter.Value')

if [ "$CURRENT_AMI_VERSION" != "$LATEST_AMI_VERSION" ]; then
  echo "new eks ami available: $LATEST_AMI_VERSION"
fi

export AVAILABLE_ADDON_VERSIONS=$(aws-vault exec tf.dps2 -- aws eks describe-addon-versions)
export LATEST_VPC_CNI_VERSION=$(echo $AVAILABLE_ADDON_VERSIONS | jq -r '.addons[] | select(.addonName=="vpc-cni") | .addonVersions[0] | .addonVersion')
export LATEST_COREDNS_VERSION=$(echo $AVAILABLE_ADDON_VERSIONS | jq -r '.addons[] | select(.addonName=="coredns") | .addonVersions[0] | .addonVersion')
export LATEST_KUBE_PROXY_VERSION=$(echo $AVAILABLE_ADDON_VERSIONS | jq -r '.addons[] | select(.addonName=="kube-proxy") | .addonVersions[0] | .addonVersion')

if [ $DESIRED_VPC_CNI_VERSION != $LATEST_VPC_CNI_VERSION ]; then
  echo "new vpc-cni version available: $LATEST_VPC_CNI_VERSION"
fi

if [ $DESIRED_COREDNS_VERSION != $LATEST_COREDNS_VERSION ]; then
  echo "new coredns version available: $LATEST_COREDNS_VERSION"
fi

if [ $DESIRED_KUBE_PROXY_VERSION != $LATEST_KUBE_PROXY_VERSION ]; then
  echo "new kube-proxy version available: $LATEST_KUBE_PROXY_VERSION"
fi
