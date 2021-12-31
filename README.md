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

* OIDC for service accounts (irsa) installed and used by resulting admin kubeconfig
* control plane logging default = "api", "audit", "authenticator"
* control plan internals encrypted using managed kms key
* AWS Managed node_groups for worker pools
  * _note._ managed node groups do not currently permit the docker bridge network to be accessible.
* eks addons activated:
  * vpc-cni
  * coredns
  * kube-proxy
* default EKS storage class (EBS)
* creates the custom, system namespace `lab-system` to be used by cluster owners for non-istio-controlled services or testing
* See release notes for current release versions

## upgrade How-tos

**upgrade managed node_groups**

AWS releases regular eks-optimized aws linux 2 version updates. This is for all the usual reasons - upgrade and refinements to al2, security patches, kublet updates, etc. Approving the plan configuration for application will result in a terraform taint of the managed node group so that the latest ami version will be used.  

**upgrade kubernetes and addon version**

Minor EKS/Kubernetes version upgrades are performed by AWS automatically as they are released.  

AWS also managed major version upgrades and upgrades to the eks addons but these must be triggered by the pipeline. To trigger these aws-managed, automated version upgrades, edit the specified version in tfvars file.  

Ex:
```bash
{
  ...
  "cluster_version": "1.21",  # <= upgrade to next version by changing to "1.22"
  "amazon_vpc_cni_version": "v1.10.1-eksbuild.1",
  "coredns_version": "v1.8.4-eksbuild.1",
  "kube_proxy_version": "v1.21.2-eksbuild.2",
  ...
}
```

**The nightly `version-check` job will notify of available new AMIs or addon versions.**  

_Note._ Must upgrade to each major version as release; don't skip over a version.  

# NEED TODO

- add eks major version release check
- convert to datadog as soon as funding in place
- no operational monitors defined
