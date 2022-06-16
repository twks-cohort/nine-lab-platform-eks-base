resource "aws_eks_addon" "kube_proxy" {
  cluster_name             = var.cluster_name
  addon_name               = "kube-proxy"
  addon_version            = var.kube_proxy_version
  resolve_conflicts        = "OVERWRITE"

  depends_on = [ module.eks.cluster_id ]
}
