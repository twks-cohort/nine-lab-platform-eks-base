#!/usr/bin/env bash
export NODE_GROUP=$1

if [[ -v $TAINT ]]; then
  echo "TAINT is set"
else
  echo "TAINT is not set"
fi

# if [[ -v $TAINT ]]; then
#   terraform taint "module.eks.module.node_groups.random_pet.node_groups[\"${NODE_GROUP}\"]"
#   terraform taint "module.eks.module.node_groups.aws_eks_node_group.workers[\"${NODE_GROUP}\"]"
# fi

# use circleci api to clear TAINT
