#!/usr/bin/env bats

@test "validate dynamic ebs volume claim resized" {
  run bash -c "kubectl get pvc -n lab-system | grep 'claim-test-pod'"
  [[ "${output}" =~ "6Gi" ]]
}
