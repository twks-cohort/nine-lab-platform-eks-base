#!/usr/bin/env bash
export NODE_GROUPS=$1
export TERRAFORM_STEP=$2

echo "DEBUG:"
echo "TAG = ${CIRCLE_TAG}"
echo "NODE_GROUPS = ${NODE_GROUPS}"
echo "TERRAFORM_STEP = ${TERRAFORM_STEP}"

if [[ "$CIRCLE_TAG" == *"taint"* ]]; then
  case $TERRAFORM_STEP in
    plan)
      echo -n "managed node groups scheduled for taint [${NODE_GROUPS}]"
      ;;

    apply)
      echo -n "Apply taint to managed node groups [${NODE_GROUPS}]"
      terraform taint "module.eks.module.node_groups.aws_eks_node_group.workers[\"${NODE_GROUPS}\"]"
      ;;

    *)
      echo -n "error: unknown terraform step (${TERRAFORM_STEP}) provided to taint_node_groups.sh"
      exit 1
      ;;
  esac
else
  echo -n "no TAINT scheduled"
fi
