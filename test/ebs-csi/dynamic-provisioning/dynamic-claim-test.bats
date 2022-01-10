#!/usr/bin/env bats

@test "validate dynamic ebs volume claim created" {
  run bash -c "kubectl describe pv | grep 'lab-system/test-ebs-claim'"
  [[ "${output}" =~ "Claim" ]]
}

@test "validate claim-test-pod health" {
  run bash -c "kubectl get all -n lab-system | grep 'pod/claim-test-pod'"
  [[ "${output}" =~ "Running" ]]
}

@test "validate dynamic ebs pvc write access" {
  run bash -c "kubectl exec -it claim-test-pod cat /data/out.txt -n lab-system"
  [[ "${output}" =~ "UTC" ]]
}

