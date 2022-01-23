#!/usr/bin/env bats

@test "validate vpc-cni status" {
  run bash -c "kubectl get daemonset aws-node -n kube-system -o json | grep $DESIRED_VPC_CNI_VERSION"
  [[ "${output}" =~ "image" ]]
}

# use only if customizing the setting
# @test "validate aws-node WARM_IP_TARGET" {
#   run bash -c "kubectl get ds aws-node -n kube-system -o=jsonpath='{.spec.template.spec.containers[].env}'"
#   [[ "${output}" =~ "{\"name\":\"WARM_IP_TARGET\",\"value\":\"15\"}" ]]
# }

@test "validate kube-proxy status" {
  run bash -c "kubectl get daemonset kube-proxy -n kube-system -o json | grep $DESIRED_KUBE_PROXY_VERSION"
  [[ "${output}" =~ "image" ]]
}

@test "validate coredns status" {
  run bash -c "kubectl get deployment coredns -n kube-system -o json | grep $DESIRED_COREDNS_VERSION"
  [[ "${output}" =~ "image" ]]
}

# 
@test "validate aws-ebs-csi-driver status" {
  run bash -c "kubectl get deployment ebs-csi-controller -n kube-system -o json | grep $DESIRED_EBS_CSI_VERSION"
  [[ "${output}" =~ "image" ]]
}
