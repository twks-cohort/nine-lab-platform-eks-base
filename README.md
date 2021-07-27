<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 />
    <br />
		<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/dps_lab_title.png?sanitize=true" width=350/>
	</p>
  <h3>lab-platform-eks</h3>
</div>
<br />


## current configuration

* Current configuration has twdps.digital as the DPS-2 domain
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
* EKS default storage class (EBS)
* See [CHANGELOG.md](./CHANGELOG.md) for current release versions

## CloudWatch Container Insights

Refer to the ContainerInsights tab on Cloudwatch for metrics and logging aggregation.

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

AWS releases multiple eks-optimized aws linux 2 version updates. This is for all the usual reasons - upgrade and refinements to al2, security patches, kublet updates, etc. To update to the latest ami release for the current k8s version of a cluster:

Include `-taint` in the release tag to trigger a deployment, starting from sandbox, that will taint the managed node groups prior to performing the terraform apply.

# NEED TODO

- not forwarding kube-state-metrics to container-insights

Standard tests not inclued in pipeline:

- test cluster-autoscaler response to load
- test to confirm aws container-insight aggregation is occuring
- no operational monitors defined
