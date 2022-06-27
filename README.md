<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 />
    <br />
		<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/dps_lab_title.png?sanitize=true" width=350/>
	</p>
  <br />
  <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
  <br />
  <h3>lab-platform-eks-base</h3>
  <a href="https://app.circleci.com/pipelines/github/ThoughtWorks-DPS/lab-platform-eks-base"><img src="https://circleci.com/gh/ThoughtWorks-DPS/lab-platform-eks-base.svg?style=shield"></a> <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
</div>
<br />

<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/lab-platform-eks/main/pipeline.png?sanitize=true" width=800 />
	</p>
</div>
<br />

## current configuration

* OIDC for service accounts (irsa) enabled and used by resulting admin kubeconfig, and for assumable roles
* control plane logging default = "api", "audit", "authenticator", "controllerManager", "scheduler"
* control plan internals encrypted using managed kms key
* AWS Managed node_groups for worker pools
  * _note._ managed node groups do not currently permit the docker bridge network to be accessible.
* eks addons activated:
  * vpc-cni, with required role
  * coredns
  * kube-proxy
  * aws-ebs-csi-driver, with required role (note: storage class definition managed in core-services pipeline)
* See release notes for current release versions

**IMPORTANT: When creating a new cluster**

Currently the terraform `taint` job does not first look for the existence of the managed node group. Therefore when creating a new cluster you must set the step to not perform the taint else the job will fail.  

### Radiators and Monitors

Given that the observability agents (datadog is used by the lab) are managed by the -core-services pipeline, on the first release of this -eks-base pipeline deploying dashbaords and monitors is not possible. Come back and add the configuration after getting the deployments working in -eks-core-services.  

The clusters monitors are the same for each cluster and deployed with the cluster, whereas the dashboard incorporates all clusters and is deployed by git push.  

As with this repo/pipieline, the dashboard and monitors deployed by a pipeline are concerned with the services managed within the pipeline.

_Note. While effective and simple, the dahsboard and monitor deployments would benefits from a clean, resusable abstraction._  

## upgrade How-tos

**upgrade managed node_groups**

AWS releases regular eks-optimized aws linux 2 version updates. This is for all the usual reasons - upgrade and refinements to al2, security patches, kublet updates, etc. Each time the terraform plan is applied will result in a terraform taint of the managed node group so that the latest ami version will be used in a rolling update of nodes.  

**upgrade kubernetes and addon version**

Minor EKS/Kubernetes version upgrades are performed by AWS automatically as they are released.  

AWS will manage version updates and upgrades to the eks addons but these must be triggered by the pipeline. To trigger these aws-managed, automated version upgrades, edit the specified version in tfvars file.  

Ex:
```bash
{
  ...
  "cluster_version": "1.21",                       # <= change these eks or addon versions to trigger aws managed upgrade
  "vpc_cni_version": "v1.11.0-eksbuild.1",
  "coredns_version": "v1.8.7-eksbuild.1",
  "kube_proxy_version": "v1.22.6-eksbuild.1",
  "aws_ebs_csi_version": "v1.6.1-eksbuild.1",
  ...
}
```

**WARM_IP_TARGET**  

Commented section manages the WARM_IP_TARGET setting. This effects the number of IP's the aws_vpc_cni on the node will reserve to assign to pods. A higher number results is fewer available ips in the subnet for use by the ASG but a generally faster pod allocation. This recently became a '1' by default.  

**The nightly `version-check` job will notify of available new AMIs or addon versions.**  

_Note._ Must upgrade to each major version as release; don't skip over a version.  

## Maintainers

- the datadog monitor and dashboard update scripts are simplistic and there is obviously refactoring needed to turn that into a standard piece of code with functionality accessed via an orb or something similar
- the validate test confirms the actual version running matches the desired version. The Dashboard dependency check is a comparison between desired version and latest.

**Deleting ns stuck in terminating**  

The issue is tied to removing finalizers and/or services still running in a namespace that are somewhat hidden. The krew plugin get-all can help with finding those other artifacts in the namespace, but to force a deletion:  

1. Directly edit the ns via `$ kubectl edit ns the-namespace` and remove any remaining finalizers.  

2. From one terminal window run `kubectl proxy` and then from another terminal window run the following:
```bash
$ kubectl get ns the-namespace -o json | \
  jq '.spec.finalizers=[]' | \
  curl -X PUT http://localhost:8001/api/v1/namespaces/the-namespace/finalize -H "Content-Type: application/json" --data @-
```
