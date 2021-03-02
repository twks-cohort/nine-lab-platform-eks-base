#!/usr/bin/env bash
set -e

# parameters
# $1 = cluster config to use
export CLUSTER=${1}

# export AWS_ACCOUNT_ID=$(cat tpl/${CLUSTER}.json | jq -r '.account_id')
export DOMAIN=$(cat tpl/${CLUSTER}.json | jq -r '.domain')
# export CERT_MANAGER_VERSION=$(cat tpl/${CLUSTER}.json | jq -r '.cert_manager_version')
# export EMAIL=$(cat tpl/${CLUSTER}.json | jq -r '.cert_manager_issuer_email')
# export AWS_DEFAULT_REGION=$(cat tpl/${CLUSTER}.json | jq -r '.aws_region')
# export ISSUER_ENDPOINT=$(cat tpl/${CLUSTER}.json | jq -r '.issuerEndpoint')


kubectl apply -f cluster_domain_certificate_issuer.yaml

cat <<EOF > cluster_default_certificates.yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: $CLUSTER.$DOMAIN-certificate
  namespace: istio-system
spec:
  secretName: $CLUSTER.$DOMAIN-certificate
  issuerRef:
    name: letsencrypt-$CLUSTER-issuer
    kind: ClusterIssuer
  commonName: $CLUSTER.$DOMAIN-certificate
  dnsNames:
  - $CLUSTER.$DOMAIN
  - '*.$CLUSTER.$DOMAIN'
EOF
