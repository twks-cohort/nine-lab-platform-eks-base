# lab-platform-eks

## current configuration

- Uses EKS latest k8s version (1.19)
- Control plane logging default = "api", "audit", "authenticator"
- Control plan internals encrypted using generated kms key
- Uses managed node_groups for worker pools
- OIDC for service accounts (irsa) is configured and used for cluster-autoscaler, cloud-watch, external-dns
- baseline config includes
- - metrics-server
- - kube-state-metrics
- - cluster-autoscaler
- - AWS container-insights (log/metrics aggregation)
- Not configured to support "stateful" applications backed by EBS volumes


## Run bats test
```sh
brew install bats
aws-vault exec <role> bats test
```

## upgrade How-tos

**upgrade kubernetes version**

EKS performs minor version upgrade automatically in this labs configuration. To before major version upgrades, edit k8s version as specified in tfvars file. Must upgrade to each major version as release; don't skip over a version.

Ex:
```bash
{
  ...
  "cluster_version": "1.18",  # <= upgrade to next version by changing to "1.19"
}
```

**upgrade managed node_groups**

AWS releases multiple eks-optimized aws linux 2 version updates. This is for all the usual reasons - upgrade and refinements to al2, security patches, kublet updates, etc. To update to the latest ami release for the k8s version of a cluster:

```bash
$ terraform taint "module.eks.module.node_groups.random_pet.node_groups[\"side_a\"]"
$ terraform taint "module.eks.module.node_groups.aws_eks_node_group.workers[\"side_a\"]"
```



# NEED TODO

- run sonobuoy conformance tests

# not yet

- not forwarding kube-state-metrics to container-insights, probably not necessary for poc

Given poc, limited configuration testing to the basics. operational deployment would require:

- test metrics-server and kube-state-metrics for actual outputs and test aggregation for presence of the metrics
- test aws container-insight aggregation for results
- test cluster-autoscaler response to load
