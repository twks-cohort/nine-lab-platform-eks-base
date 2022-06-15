#!/usr/bin/env bash
set -e

function version_alert() {
  export TABLE_COLOR=$ALERT_TABLE_COLOR
  # every 7 days, also send a slack message
  if (( "$(date +%d)" % 7 )); then
    curl -X POST -H 'Content-type: application/json' --data '{"Notice":"$1"}' $SLACK_LAB_EVENTS
  fi
}

export CLUSTER=$1
export AWS_ASSUME_ROLE=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_assume_role)
export AWS_DEFAULT_REGION=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_region)
export AWS_ACCOUNT_ID=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_account_id)

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ASSUME_ROLE --role-session-name lab-platform-eks-base > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

# current versions table
export TABLE="| dependency | sandbox-us-east-2 | prod-us-east-1 |\\\\n|----|----|----|\\\\n"
export EKS_VERSIONS="| eks |"
export AMI_VERSIONS="| ami |"
export COREDNS_VERSIONS="| coredns |"
export KUBE_PROXY_VERSIONS="| kube-proxy |"
export VPC_CNI_VERSIONS="| vpc-cni |"
export EBS_CSI_VERSIONS="| ebs-csi |"

echo "generate markdown table with the desired versions of the services managed by the lab-platform-eks-base pipeline for all clusters"
declare -a clusters=(sandbox-us-east-2 prod-us-east-1)

for cluster in "${clusters[@]}";
do
  echo "cluster: $cluster"

  # append environment EKS version
  export EKS_VERSION=$(cat environments/$cluster.auto.tfvars.json.tpl | jq -r .cluster_version)
  export DESIRED_CLUSTER_VERSION=$EKS_VERSION
  export EKS_VERSIONS="$EKS_VERSIONS $EKS_VERSION |"
  echo "DESIRED_CLUSTER_VERSION: $DESIRED_CLUSTER_VERSION"

  # append environment AMI version
  export CLUSTER_NODES=$(aws ec2 describe-instances --filter "Name=tag:kubernetes.io/cluster/$cluster,Values=owned")
  export CURRENT_AMI_VERSION=$(echo $CLUSTER_NODES | jq -r '.Reservations | .[0] | .Instances | .[0] | .ImageId')
  export AMI_VERSIONS="$AMI_VERSIONS ${CURRENT_AMI_VERSION:-} |"
  echo "CURRENT_AMI_VERSION: $CURRENT_AMI_VERSION"

  # append environment coreDNS version
  export DESIRED_COREDNS_VERSION=$(cat environments/$cluster.auto.tfvars.json.tpl | jq -r .coredns_version)
  export COREDNS_VERSIONS="$COREDNS_VERSIONS $DESIRED_COREDNS_VERSION |"
  echo "DESIRED_COREDNS_VERSION: $DESIRED_COREDNS_VERSION"

  # append environment kube-proxy version
  export DESIRED_KUBE_PROXY_VERSION=$(cat environments/$cluster.auto.tfvars.json.tpl | jq -r .kube_proxy_version)
  export KUBE_PROXY_VERSIONS="$KUBE_PROXY_VERSIONS $DESIRED_KUBE_PROXY_VERSION |"
  echo "DESIRED_KUBE_PROXY_VERSION: $DESIRED_KUBE_PROXY_VERSION"

  # append environment VPC-CNI version
  export DESIRED_VPC_CNI_VERSION=$(cat environments/$cluster.auto.tfvars.json.tpl | jq -r .vpc_cni_version)
  export VPC_CNI_VERSIONS="$VPC_CNI_VERSIONS $DESIRED_VPC_CNI_VERSION |"
  echo "DESIRED_VPC_CNI_VERSION: $DESIRED_VPC_CNI_VERSION"

  # append environment EBS-CSI version
  export DESIRED_EBS_CSI_VERSION=$(cat environments/$cluster.auto.tfvars.json.tpl | jq -r .aws_ebs_csi_version)
  export EBS_CSI_VERSIONS="$EBS_CSI_VERSIONS $DESIRED_EBS_CSI_VERSION |"
  echo "DESIRED_EBS_CSI_VERSION: $DESIRED_EBS_CSI_VERSION"

done

# assumeble markdown table
export CURRENT_TABLE="$TABLE$EKS_VERSIONS\\\\n$AMI_VERSIONS\\\\n$COREDNS_VERSIONS\\\\n$KUBE_PROXY_VERSIONS\\\\n$VPC_CNI_VERSIONS\\\\n$EBS_CSI_VERSIONS\\\\n"

# current versions table
declare TABLE="| available |\\\\n|----|\\\\n"
declare EKS_VERSIONS="| - |"
declare AMI_VERSIONS="|"
declare COREDNS_VERSIONS="|"
declare KUBE_PROXY_VERSIONS="|"
declare VPC_CNI_VERSIONS="|"
declare EBS_CSI_VERSIONS="|"

echo "generate markdown table with the available versions of the services managed by the lab-platform-eks-base pipeline for all clusters"

# fetch the current ami release versions available. Use this for bottlerocket= /aws/service/bottlerocket/aws-k8s-$DESIRED_CLUSTER_VERSION/x86_64/latest/image_id
export LATEST_AMI_VERSION=$(aws ssm get-parameter --name /aws/service/eks/optimized-ami/$DESIRED_CLUSTER_VERSION/amazon-linux-2/recommended/image_id --region $AWS_DEFAULT_REGION | jq -r '.Parameter.Value')
export AMI_VERSIONS="$AMI_VERSIONS $LATEST_AMI_VERSION |"
echo "LATEST_AMI_VERSION: $LATEST_AMI_VERSION"

export AVAILABLE_ADDON_VERSIONS=$(aws eks describe-addon-versions)

# fetch the current coredns version available
export LATEST_COREDNS_VERSION=$(echo $AVAILABLE_ADDON_VERSIONS | jq -r '.addons[] | select(.addonName=="coredns") | .addonVersions[0] | .addonVersion')
export COREDNS_VERSIONS="$COREDNS_VERSIONS $LATEST_COREDNS_VERSION |"
echo "LATEST_COREDNS_VERSION: $LATEST_COREDNS_VERSION"

# fetch the current kube-proxy version available
export LATEST_KUBE_PROXY_VERSION=$(echo $AVAILABLE_ADDON_VERSIONS | jq -r '.addons[] | select(.addonName=="kube-proxy") | .addonVersions[0] | .addonVersion')
export KUBE_PROXY_VERSIONS="$KUBE_PROXY_VERSIONS $LATEST_KUBE_PROXY_VERSION |"
echo "LATEST_KUBE_PROXY_VERSION: $LATEST_KUBE_PROXY_VERSION"

# fetch the current vpc-cni version available
export LATEST_VPC_CNI_VERSION=$(echo $AVAILABLE_ADDON_VERSIONS | jq -r '.addons[] | select(.addonName=="vpc-cni") | .addonVersions[0] | .addonVersion')
export VPC_CNI_VERSIONS="$VPC_CNI_VERSIONS $LATEST_VPC_CNI_VERSION |"
echo "LATEST_VPC_CNI_VERSION: $LATEST_VPC_CNI_VERSION"

# fetch the current ebs-csi version available
export LATEST_EBS_CSI_VERSION=$(echo $AVAILABLE_ADDON_VERSIONS | jq -r '.addons[] | select(.addonName=="aws-ebs-csi-driver") | .addonVersions[0] | .addonVersion')
export EBS_CSI_VERSIONS="$EBS_CSI_VERSIONS $LATEST_EBS_CSI_VERSION |"
echo "LATEST_EBS_CSI_VERSION: $LATEST_EBS_CSI_VERSION"

# assumeble markdown table
export LATEST_TABLE="$TABLE$EKS_VERSIONS\\\\n$AMI_VERSIONS\\\\n$COREDNS_VERSIONS\\\\n$KUBE_PROXY_VERSIONS\\\\n$VPC_CNI_VERSIONS\\\\n$EBS_CSI_VERSIONS\\\\n"

echo "check production current versions against latest"
export TABLE_COLOR="green"
export ALERT_TABLE_COLOR="pink"

if [[ $CURRENT_AMI_VERSION != $LATEST_AMI_VERSION ]]; then
  version_alert
fi
if [[ $DESIRED_COREDNS_VERSION != $LATEST_COREDNS_VERSION ]]; then
  version_alert "New EKS AMI version available: $LATEST_AMI_VERSION"
fi
if [[ $DESIRED_KUBE_PROXY_VERSION != $LATEST_KUBE_PROXY_VERSION ]]; then
  version_alert "New EKS kube-proxy version available: $LATEST_KUBE_PROXY_VERSION"
fi
if [[ $DESIRED_VPC_CNI_VERSION != $LATEST_VPC_CNI_VERSION ]]; then
  version_alert " New EKS vpc-cni version available: $LATEST_VPC_CNI_VERSION"
fi
if [[ $DESIRED_EBS_CSI_VERSION != $LATEST_EBS_CSI_VERSION ]]; then
  version_alert " New EKS ebs-csi version available: $LATEST_EBS_CSI_VERSION"
fi

echo "insert markdown into dashboard.json"
cp tpl/dashboard.json.tpl observe/dashboard.json

if [[ $(uname) == "Darwin" ]]; then
  gsed -i "s/CURRENT_TABLE/$CURRENT_TABLE/g" observe/dashboard.json
  gsed -i "s/LATEST_TABLE/$LATEST_TABLE/g" observe/dashboard.json
  gsed -i "s/TABLE_COLOR/$TABLE_COLOR/g" observe/dashboard.json
else
  sed -i "s/CURRENT_TABLE/$CURRENT_TABLE/g" observe/dashboard.json
  sed -i "s/LATEST_TABLE/$LATEST_TABLE/g" observe/dashboard.json
  sed -i "s/TABLE_COLOR/$TABLE_COLOR/g" observe/dashboard.json
fi

python scripts/dashboard.py
