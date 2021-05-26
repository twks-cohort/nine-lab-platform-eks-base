<div align="center">
	<p>
		<img alt="CircleCI Logo" src="https://github.com/ThoughtWorks-DPS/lab-documentation/blob/master/doc/img/dps-lab.png?sanitize=true" width="75" />
	</p>
  <h3>ThoughtWorks DPS Lab</h3>
  <h5>lab-platform-eks</h5>
</div>
<br />

## current configuration

* OIDC for service accounts (irsa) installed and used by core services
* Control plane logging default = "api", "audit", "authenticator"
* Control plan internals encrypted using generated kms key
* Uses managed node_groups for worker pools
  * _note._ managed node groups do not currently permit the docker bridge network to be accessible. If you will be doing CI (running self-managed executors) use ordinary worker_groups.
* core cluster services installed:
  * metrics-server
  * kube-state-metrics
  * cluster-autoscaler
  * AWS container-insights (log/metrics aggregation)
  * External-DNS
  * Certificate-Manager
* EKS default storage class (EBS)
* See [CHANGELOG.md](./CHANGELOG.md) for current release versions

## upgrade How-tos

**upgrade kubernetes version**

EKS performs minor version upgrade automatically in this labs configuration. To perform major version upgrades, edit k8s version as specified in tfvars file. Must upgrade to each major version as release; don't skip over a version.

Ex:
```bash
{
  ...
  "cluster_version": "1.20",  # <= upgrade to next version by changing to "1.21"
}
```

**upgrade managed node_groups**

AWS releases multiple eks-optimized aws linux 2 version updates. This is for all the usual reasons - upgrade and refinements to al2, security patches, kublet updates, etc. To update to the latest ami release for the k8s version of a cluster:

Exploring options for the best way to operationalize.

__option 1__
Define a pipeline ENV variable in the CircleCI GUI called TAINT = True, and run the last successful build.

There is a pipeline step that runs after `terraform init` that will apply the taints to the managed node_groups.

After the successful completion of the update, remove the ENV var.

__options 2__

With the appropriate credentials. From the command line, select the desired workspace (env) and apply the taint directly.
```bash
$ terraform init
$ terraform workspace select sandbox
$ terraform taint "module.eks.module.node_groups.random_pet.node_groups[\"side_a\"]"
$ terraform taint "module.eks.module.node_groups.aws_eks_node_group.workers[\"side_a\"]"
```
and run the last successful build.

# NEED TODO

- run sonobuoy conformance tests

# not yet

- not forwarding kube-state-metrics to container-insights, probably not necessary for poc

Given poc, limited configuration testing to the basics. operational deployment would require:

- test metrics-server and kube-state-metrics for actual outputs and test aggregation for presence of the metrics
- test aws container-insight aggregation for results
- test cluster-autoscaler response to load
