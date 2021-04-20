#!/usr/bin/env bash
set -e

# parameters
# $1 = cluster config to use
export CLUSTER=${1}

export DOMAIN=$(cat ${CLUSTER}.auto.tfvars.json | jq -r '.domain')

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

kubectl apply -f cluster_default_certificates.yaml
