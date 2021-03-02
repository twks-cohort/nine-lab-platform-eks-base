#!/usr/bin/env bash
set -e

# parameters
# $1 = cluster config to use
export CLUSTER=${1}

cat <<EOF > cert-manager-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager
EOF

export AWS_ACCOUNT_ID=$(cat tpl/${CLUSTER}.json | jq -r '.account_id')
export DOMAIN=$(cat tpl/${CLUSTER}.json | jq -r '.domain')
export CERT_MANAGER_VERSION=$(cat tpl/${CLUSTER}.json | jq -r '.cert_manager_version')
export EMAIL=$(cat tpl/${CLUSTER}.json | jq -r '.cert_manager_issuer_email')
export AWS_DEFAULT_REGION=$(cat tpl/${CLUSTER}.json | jq -r '.aws_region')
export ISSUER_ENDPOINT=$(cat tpl/${CLUSTER}.json | jq -r '.issuerEndpoint')

kubectl apply -f cert-manager-namespace.yaml

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --wait -i cert-manager jetstack/cert-manager --namespace cert-manager --version v${CERT_MANAGER_VERSION} --set installCRDs=true --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::${AWS_ACCOUNT_ID}:role/${CLUSTER}-cert-manager -f tpl/values.cert_manager.yaml
sleep 15

cat <<EOF > cluster_domain_certificate_issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-$CLUSTER-issuer
  namespace: cert-manager
spec:
  acme:
    server: $ISSUER_ENDPOINT
    email: $EMAIL
    privateKeySecretRef:
      name: letsencrypt-$CLUSTER
    solvers:
    - selector:
        dnsZones:
          - "$CLUSTER.$DOMAIN"
      dns01:
        route53:
          region: $AWS_DEFAULT_REGION
          # hostedZoneID: DIKER8JEXAMPLE # optional, see policy above
          # role: arn:aws:iam::$AWS_ACCOUNT_ID:role/$CLUSTER-cert-manager
EOF
