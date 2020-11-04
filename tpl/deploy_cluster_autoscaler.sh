#!/usr/bin/env bash
export CLUSTER=$1
export AWS_ACCOUNT_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .account_id)
export AWS_DEFAULT_REGION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_region)

# write cluster-autoscaler-chart-values.yaml
cat <<EOF > cluster-autoscaler-chart-values.yaml
awsRegion: ${AWS_DEFAULT_REGION}

rbac:
  create: true
  serviceAccountAnnotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::${AWS_ACCOUNT_ID}:role/${CLUSTER}-cluster-autoscaler"

autoDiscovery:
  clusterName: ${CLUSTER}
  enabled: true

extraArgs:
  skip-nodes-with-local-storage: false
  expander: least-waste
  balance-similar-node-groups: true
  skip-nodes-with-system-pods: false

EOF

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm template $CLUSTER stable/cluster-autoscaler --namespace kube-system  --values=cluster-autoscaler-chart-values.yaml > cluster-autoscaler-deployment.yaml
kubectl apply -n kube-system -f cluster-autoscaler-deployment.yaml
