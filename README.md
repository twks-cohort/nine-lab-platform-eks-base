<div align="center">
	<p>
		<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 />
    <br />
		<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/dps_lab_title.png?sanitize=true" width=350/>
	</p>
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

* OIDC for service accounts (irsa) installed and used by resulting admin kubeconfig, and for oidc-assumable roles
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

**changes in since eks/K8s 1.20**

In 1.19 and prior, the following tags needed to be self-managed (unless using eksctl, aws cli, or the console):  

"kubernetes.io/cluster/${var.cluster_name}" = "owned"  
"k8s.io/cluster-autoscaler/enabled" = "true"  
"k8s.io/cluster-autoscaler/${var.cluster_name}" = "true"  

Now these are applied by default.  

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
  "cluster_version": "1.21",  # <= upgrade to next version by changing to "1.22"
  "amazon_vpc_cni_version": "v1.10.1-eksbuild.1",
  "coredns_version": "v1.8.4-eksbuild.1",
  "kube_proxy_version": "v1.21.2-eksbuild.2",
  ...
}
```

**WARM_IP_TARGET**  

Commented section manages the WARM_IP_TARGET setting. This effects the number of IP's the aws_vpc_cni on the node will reserve to assign to pods. A higher number results is fewer available ips in the subnet for use by the ASG but a generally faster pod allocation. This recently became a '1' by default.  

**The nightly `version-check` job will notify of available new AMIs or addon versions.**  

_Note._ Must upgrade to each major version as release; don't skip over a version.  

**Delete aws-auth configmap after destroy**

Known issue related to cleanly destroying EKS cluster. Remove the aws-auth configmap manually to resolve:  

```
$ terraform state rm 'module.eks.kubernetes_config_map.aws_auth[0]'
```
**Deleting ns stuck in terminating**  

The issue is tied to removing finalizers and/or services still running in a namespace that are somewhat hidden. The krew plugin get-all can help with finding those other artifacts in the namespace, but to force a deletion:  

1. Directly edit the ns via `$ kubectl edit ns the-namespace` and remove any remaining finalizers.  

2. From one terminal window run `kubectl proxy` and then from another terminal window run the following:
```bash
$ kubectl get ns the-namespace -o json | \
  jq '.spec.finalizers=[]' | \
  curl -X PUT http://localhost:8001/api/v1/namespaces/the-namespace/finalize -H "Content-Type: application/json" --data @-
```

# NEED TODO

- add eks major version release check
- convert to datadog as soon as funding in place
- no operational monitors defined
