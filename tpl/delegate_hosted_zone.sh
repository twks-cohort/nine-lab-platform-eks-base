#!/usr/bin/env bash
export CLUSTER=$1
export AWS_ACCOUNT=$(cat $CLUSTER.auto.tfvars.json | jq -r .account_id)
export AWS_DEFAULT_REGION=$(cat $CLUSTER.auto.tfvars.json | jq -r .aws_region)
export AWS_DOMAIN_ACCOUNT=$(cat $CLUSTER.auto.tfvars.json | jq -r .domain_account)
export DOMAIN=$(cat $CLUSTER.auto.tfvars.json | jq -r .domain)

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT:role/DPSTerraformRole --role-session-name delegate-zone > credentials
export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

export SUBDOMAIN_ZONE_ID=$(aws route53 list-hosted-zones | jq -r --arg SUBDOMAIN "$CLUSTER.$DOMAIN." '.HostedZones[] | select(.Name==$SUBDOMAIN) | .Id')
export NAME_SERVERS=$(aws route53 get-hosted-zone --id $SUBDOMAIN_ZONE_ID | jq .DelegationSet.NameServers)

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_DOMAIN_ACCOUNT:role/DPSTerraformRole --role-session-name delegate-zone > credentials
export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

export PARENT_ZONE_ID=$(aws route53 list-hosted-zones | jq -r  --arg DOMAIN "$DOMAIN." '.HostedZones[] | select(.Name==$DOMAIN) | .Id')
echo $PARENT_ZONE_ID
echo "Creating NS records for $CLUSTER.$DOMAIN in parent zone"

cat <<EOF > subdomain.json
{
  "Comment": "Create a subdomain NS record in the $DOMAIN domain",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$CLUSTER.$DOMAIN",
        "Type": "NS",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$(echo $NAME_SERVERS | jq -r '.[0]')"
          },
          {
            "Value": "$(echo $NAME_SERVERS | jq -r '.[1]')"
          },
          {
            "Value": "$(echo $NAME_SERVERS | jq -r '.[2]')"
          },
          {
            "Value": "$(echo $NAME_SERVERS | jq -r '.[3]')"
          }
        ]
      }
    }
  ]
}
EOF

aws route53 change-resource-record-sets --hosted-zone-id $PARENT_ZONE_ID --change-batch file://subdomain.json
