#!/usr/bin/env bats

@test "evaluate metrics-server status" {
  run bash -c "kubectl get po -n kube-system -o wide | grep 'metrics-server'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate kube-state-metrics status" {
  run bash -c "kubectl get po -n kube-system -o wide | grep 'kube-state-metrics'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate cluster-autoscaler status" {
  run bash -c "kubectl get po -n kube-system -o wide | grep 'cluster-autoscaler'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate cloudwatch-agent status" {
  run bash -c "kubectl get po -n amazon-cloudwatch -o wide | grep 'cloudwatch-agent'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate fluentd status" {
  run bash -c "kubectl get po -n amazon-cloudwatch -o wide | grep 'fluentd'"
  [[ "${output}" =~ "Running" ]]
}

@test "evaluate external-dns status" {
  run bash -c "kubectl get po -n kube-system -o wide | grep 'external-dns'"
  [[ "${output}" =~ "Running" ]]
}

# @test "evaluate cert-manager status" {
#   run bash -c "kubectl get po --selector=app=cert-manager -n cert-manager -o wide | grep 'cert-manager'"
#   [[ "${output}" =~ "Running" ]]
# }
