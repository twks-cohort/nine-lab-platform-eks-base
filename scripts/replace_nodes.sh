#!/usr/bin/env bash
set -e

CLUSTER=$1
export AWS_DEFAULT_REGION=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_region)
export AWS_ASSUME_ROLE=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_assume_role)
export AWS_ACCOUNT_ID=$(cat ${CLUSTER}.auto.tfvars.json | jq -r .aws_account_id)

# Set start date/time of script for datadog call at end
#STARTTIME=$(date +%s)

# Get number of nodes in the cluster
NUMNODES=$(kubectl get nodes | tail -n +2 | wc -l)
echo ${NUMNODES} nodes in the cluster


if (( NUMNODES < 3 )); then
  echo "Less than 3 nodes in the cluster; recommend diagnosing cause"
  exit 1
fi

# bash scripts/mute_jaeger_monitor.sh mute ${CLUSTER_NAME}

# Replace 1/4 of the nodes, rounding up
let TOREPLACE=$(((NUMNODES / 4) + (NUMNODES % 4 > 0)))
echo ${TOREPLACE} nodes will be replaced:

# Nodes to be replaced, sorted by creation date/time
REPLACENODES=( $(kubectl get nodes --sort-by=.metadata.creationTimestamp | tail -n +2 | head -${TOREPLACE} | awk '{ print $1 }') )
printf '%s\n' "${REPLACENODES[@]}"

for i in "${REPLACENODES[@]}"
do
  echo Replacing $i
  kubectl drain $i --ignore-daemonsets --delete-emptydir-data &

  PROCESS_ID=$!

  # Probe background jobs since CircleCI will kill a long running step if no output is produced for over 10min
  counter=0
  while jobs %% && [[ counter -lt 5 ]]; do
    echo "Waiting on kubectl node to drain..."
    echo "Retried ${counter} time(s)"
    ((counter++))
    sleep 60
  done

  # kubectl get pods --all-namespaces -o wide | grep "${$i}" | awk '{print $2 " --namespace=" $1}' | xargs kubectl delete pod
  kubectl delete node $i
done || exit 1

aws sts assume-role --output json --role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/$AWS_ASSUME_ROLE --role-session-name lab-platform-eks-base > credentials

export AWS_ACCESS_KEY_ID=$(cat credentials | jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(cat credentials | jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(cat credentials | jq -r ".Credentials.SessionToken")

for i in "${REPLACENODES[@]}"
do
  INSTANCE_ID=$(aws ec2 describe-instances --filter Name=private-dns-name,Values=$i | jq -r '.Reservations[].Instances[] | .InstanceId')
  aws ec2 terminate-instances --instance-ids ${INSTANCE_ID}
done || exit 1

kubectl get nodes
echo All planned nodes have been replaced successfully.

# echo
# echo Checking datadog events to ensure health of bookinfo app during node replacements

# # Check for any DataDog events since the script started for the bookinfo application
# ENDTIME=$(date +%s)
# events=$(curl -X GET "https://api.datadoghq.com/api/v1/events?start=${STARTTIME}&end=${ENDTIME}&tags=monitor,namespace:lhdi-bookinfo,cluster_name:${CLUSTER_NAME},monitor" \
# -H "Content-Type: application/json" \
# -H "DD-API-KEY: ${DATADOG_API_KEY}" \
# -H "DD-APPLICATION-KEY: ${DATADOG_APP_KEY}")

# bash scripts/mute_jaeger_monitor.sh unmute ${CLUSTER_NAME}

# if [[ $events != '{"events":[]}' ]]; then
#         echo Events found for the bookinfo application during node upgrades
#         echo Please check Datadog for more information
#         exit 1
# else
#         :
# fi
