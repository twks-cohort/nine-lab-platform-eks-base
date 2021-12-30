<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 />
    <br />
		<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/dps_lab_title.png?sanitize=true" width=350/>
	</p>
  <h3>lab-platform-eks</h3>
</div>
<br />

<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/lab-platform-eks/main/pipeline.png?sanitize=true" width=800 />
	</p>
</div>
<br />


## current configuration

* OIDC for service accounts (irsa) installed and used by core services
* control plane logging default = "api", "audit", "authenticator"
* control plan internals encrypted using generated kms key
* Managed node_groups for worker pools
  * _note._ managed node groups do not currently permit the docker bridge network to be accessible.
* eks addons activated:
  * vpc-cni
  * coredns
  * kube-proxy
* default EKS storage class (EBS)
* See release notes for current release versions

## upgrade How-tos

**upgrade kubernetes version**

EKS performs minor version upgrade automatically in this labs configuration. To perform major version upgrades, edit k8s version as specified in tfvars file. Must upgrade to each major version as release; don't skip over a version.

Ex:
```bash
{
  ...
  "cluster_version": "1.21",  # <= upgrade to next version by changing to "1.22"
}
```

**upgrade managed node_groups**

AWS releases regular eks-optimized aws linux 2 version updates. This is for all the usual reasons - upgrade and refinements to al2, security patches, kublet updates, etc. Approving the plan configuration for application will result in a terraform taint of the managed node group so that the latest ami version will be used.

# NEED TODO

- convert to datadog as soon as funding in place
- no operational monitors defined
