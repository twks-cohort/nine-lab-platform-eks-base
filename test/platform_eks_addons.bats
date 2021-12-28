#!/usr/bin/env bats

@test "evaluate vpc-cni status" {
  run bash -c "kubectl get daemonset aws-node -n kube-system -o json | grep $DESIRED_VPC_CNI_VERSION"
  [[ "${output}" =~ "image" ]]
}

@test "evaluate kube-proxy status" {
  run bash -c "kubectl get daemonset kube-proxy -n kube-system -o json | grep $DESIRED_KUBE_PROXY_VERSION"
  [[ "${output}" =~ "image" ]]
}

@test "evaluate corednsstatus" {
  run bash -c "kubectl get deployment coredns -n kube-system -o json | grep $DESIRED_COREDNS_VERSION"
  [[ "${output}" =~ "image" ]]
}

# @test "evaluate standard namespaces" {
#   run bash -c "kubectl get ns"
#   [[ "${output}" =~ "lab-system" ]]
# }
