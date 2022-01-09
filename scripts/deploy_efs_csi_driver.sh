#!/usr/bin/env bash
export ACCOUNT_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .account_id)

cat <<EOF > efs-csi/controller-service-account.yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: efs-csi-controller-sa
  namespace: kube-system
  labels:
    app.kubernetes.io/name: aws-efs-csi-driver
  annotations: 
    eks.amazonaws.com/role-arn: arn:aws:iam::${ACCOUNT_ID}:role/efs-csi-controller-sa

EOF
