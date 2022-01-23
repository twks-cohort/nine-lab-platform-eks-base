#!/usr/bin/env bats

@test "validate dynamic ebs volume claim resized" {
  run bash -c "kubectl get pvc -n test-ebs-csi | grep 'claim-test-pod'"
  [[ "${output}" =~ "6Gi" ]]
}
