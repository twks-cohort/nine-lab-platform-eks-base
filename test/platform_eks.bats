#!/usr/bin/env bats

@test "validate nodes reporting" {
  run bash -c "kubectl get nodes | tail -n +2 | wc -l"
  [[ "${output}" != "0" ]]
}

@test "validate nodes Ready" {
  run bash -c "kubectl get nodes | grep 'Not Ready"
  [[ "${output}" != "Not Ready" ]]
}
