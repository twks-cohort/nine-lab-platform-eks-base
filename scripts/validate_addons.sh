#!/usr/bin/env bash
export CLUSTER=$1

export DESIRED_VPC_CNI_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .vpc_cni_version)
export DESIRED_COREDNS_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .coredns_version)
export DESIRED_KUBE_PROXY_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .kube_proxy_version)
export DESIRED_EBS_CSI_VERSION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_ebs_csi_version)
export DESIRED_EBS_CSI_VERSION=$(echo "${DESIRED_EBS_CSI_VERSION%%-*}")
# validate primary addons
echo "validate addon service health"
bats test/platform_eks_addons.bats

echo "validate EBS storage class"
# validate dynamic volume provisioning

kubectl apply -f test/ebs-csi/test-storageclass.yaml
sleep 10
kubectl apply -f test/ebs-csi/dynamic-provisioning/dynamic-claim-test.yaml
sleep 25

bats test/ebs-csi/dynamic-provisioning

# test volume resizing
# resizing net yet supported in addon v1.4
# kubectl apply -f test/ebs-csi/resizing/resize-claim-test.yaml
# bats test/ebs-csi/resizing

kubectl delete -f test/ebs-csi/dynamic-provisioning/dynamic-claim-test.yaml

# validate block-volume provisioning
kubectl apply -f test/ebs-csi/block-volume/block-claim-test.yaml
sleep 25

bats test/ebs-csi/block-volume
kubectl delete -f test/ebs-csi/block-volume/block-claim-test.yaml
kubectl delete -f test/ebs-csi/test-storageclass.yaml
