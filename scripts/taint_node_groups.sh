#!/usr/bin/env bash
export NODE_GROUP=$1
export TERRAFORM_STEP=$2

if [[ -v $TAINT ]]; then
  case $TERRAFORM_STEP in
    plan)
      echo -n "node_group ${NODE_GROUP} scheduled for taint"
      ;;

    apply)
      echo -n "Apply taint to node_group ${NODE_GROUP}"
      #terraform taint "module.eks.module.node_groups.random_pet.node_groups[\"${NODE_GROUP}\"]"
      #terraform taint "module.eks.module.node_groups.aws_eks_node_group.workers[\"${NODE_GROUP}\"]"
      curl -u ${CIRCLECI_TOKEN}: --request DELETE --url https://circleci.com/api/v2/project/gh/ThoughtWorks-DPS/lab-platform-eks/envvar/TAINT
      ;;

    *)
      echo -n "error: unknown terraform step (${TERRAFORM_STEP}) provided to taint_node_groups.sh"
      exit 1
      ;;
  esac
else
  echo -n "node_group ${NODE_GROUP} NOT scheduled for taint"
fi
