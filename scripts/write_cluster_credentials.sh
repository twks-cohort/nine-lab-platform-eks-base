#!/usr/bin/env bash
export CLUSTER=$1
cat kubeconfig_$CLUSTER | secrethub write twdps/di/platform/env/$CLUSTER/cluster/kubeconfig
