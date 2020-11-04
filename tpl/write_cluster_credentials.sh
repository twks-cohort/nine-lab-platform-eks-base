#!/usr/bin/env bash
export CLUSTER=$1
export AWS_ACCOUNT_ID=$(cat $CLUSTER.auto.tfvars.json | jq -r .account_id)
export AWS_DEFAULT_REGION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_region)

# write cluster kubeconfig
sed -n '/users/q;p' kubeconfig_$CLUSTER > kubeconfig_context.tpl
cat <<EOF > kubeconfig_token.tpl
users:
- name: eks_$CLUSTER
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "$CLUSTER"
        - "--role"
        - "arn:aws:iam::${AWS_ACCOUNT_ID}:role/DPSTerraformRole"

EOF
cat kubeconfig_context.tpl kubeconfig_token.tpl > kubeconfig
cat kubeconfig | secrethub write twdps/di/platform/env/$CLUSTER/cluster/kubeconfig
