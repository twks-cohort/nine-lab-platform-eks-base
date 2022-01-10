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

sleep 15 # can get ahead of the addons coming fully up
export DESIRED_VPC_CNI_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .vpc_cni_version)
export DESIRED_COREDNS_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .coredns_version)
export DESIRED_KUBE_PROXY_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .kube_proxy_version)

# validate primary addons and standard system namespaces
bats test

# validate dynamic volume provisioning
kubectl apply -f test/ebs-csi/dynamic-provisioning/dynamic-claim-test.yaml
sleep 25

bats test/ebs-csi/dynamic-provisioning

# test volume resizing
# resizing net yet supported in addon v1.4
# kubectl apply -f test/ebs-csi/resizing/resize-claim-test.yaml
# bats test/ebs-csi/resizing

kubectl delete -f test/ebs-csi/dynamic-provisioning/dynamic-claim-test.yaml

# validate block-volume provisioning
kubectl apply -f /test/ebs-csi/block-volume/block-claim-test.yaml
sleep 25

bats test/ebs-csi/block-volume
