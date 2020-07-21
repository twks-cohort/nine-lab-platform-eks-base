#!/usr/bin/env bash
# tpl/cwagent-configmap.yaml.tpl
#
cluster_name=$1

cat  <<EOF > container-insights-monitoring/cwagent/cwagent-configmap.yaml
# create configmap for cwagent config
apiVersion: v1
data:
  cwagentconfig.json: |
    {
      "logs": {
        "metrics_collected": {
          "kubernetes": {
            "cluster_name": "${cluster_name}",
            "metrics_collection_interval": 20
          }
        },
        "force_flush_interval": 5
      },
      "metrics": {
          "metrics_collected": {
              "statsd": {
                  "service_address": ":8125"
              }
          }
      }
    }
kind: ConfigMap
metadata:
  name: cwagentconfig
  namespace: amazon-cloudwatch
