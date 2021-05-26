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

In the circleci GUI, go to the Project Settings for the lab-platform-eks pipeline and define an Environment Variable { TAINT = True }.

Re-run the last sandbox release.

Add the variable again and trigger the release-tag preview pipeline to update the preview cluster.

# NEED TODO

- run sonobuoy conformance tests

# not yet

- not forwarding kube-state-metrics to container-insights

Standard tests not inclued in pipeline:

- test to confirm aws container-insight aggregation is occuring
- test cluster-autoscaler response to load
- no operational monitors defined
