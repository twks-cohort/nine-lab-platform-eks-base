resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.cluster_name
  addon_name               = "vpc-cni"
  addon_version            = var.vpc_cni_version
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = module.vpc_cni_irsa.iam_role_arn

  depends_on = [ module.eks.cluster_id ]
}

module "vpc_cni_irsa" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.1.0"

  role_name             = "vpc_cni"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}

# module "vpc_cni_role" {
#   source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version                       = "~> 4.7"
#   create_role                   = true

#   role_name                     = "${var.cluster_name}-aws-node"
#   provider_url                  = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

#   role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
#   oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-node"]
#   number_of_role_policy_arns    = 1
# }
