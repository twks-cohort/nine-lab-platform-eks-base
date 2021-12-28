resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.cluster_name
  addon_name               = "vpc-cni"
  addon_version            = var.amazon_vpc_cni_version
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = module.vpc_cni_role.iam_role_arn

  depends_on = [ module.eks.cluster_id ]
}

module "vpc_cni_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.7"
  create_role                   = var.create_aws_node_role ? true : false

  role_name                     = "aws-node"
  provider_url                  = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-node"]
  number_of_role_policy_arns    = 1
}
