#!/usr/bin/env bash
set -e

export CLUSTER=$1
export AWS_DEFAULT_REGION=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_region)
export AWS_ASSUME_ROLE=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_assume_role)
export AWS_ACCOUNT_ID=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_account_id)

echo "debug:"
echo "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"
echo "AWS_ASSUME_ROLE=$AWS_ASSUME_ROLE"

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ASSUME_ROLE --role-session-name lab-platform-eks-base > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

declare -a clusters=(sandbox-us-east-2 prod-us-east-1)

echo "generate markdown table with the desired versions of the services managed by the lab-platform-eks-base pipeline for all clusters"
for cluster in "${clusters[@]}";
do
  echo "cluster: $cluster"


  # append environment AMI version
  export CLUSTER_NODES=$(aws ec2 describe-instances --filter "Name=tag:kubernetes.io/cluster/$cluster,Values=owned")
  export CURRENT_AMI_VERSION=$(echo $CLUSTER_NODES | jq -r '.Reservations | .[0] | .Instances | .[0] | .ImageId')
  echo "$cluster ami version: $CURRENT_AMI_VERSION"


done

# fetch the current ami release versions available. Use this for bottlerocket= /aws/service/bottlerocket/aws-k8s-$DESIRED_CLUSTER_VERSION/x86_64/latest/image_id
export LATEST_AMI_VERSION=$(aws ssm get-parameter --name /aws/service/eks/optimized-ami/$DESIRED_CLUSTER_VERSION/amazon-linux-2/recommended/image_id --region $AWS_DEFAULT_REGION | jq -r '.Parameter.Value')
echo "LATEST_AMI_VERSION: $LATEST_AMI_VERSION"
