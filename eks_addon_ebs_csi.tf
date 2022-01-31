resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.aws_ebs_csi_version
  resolve_conflicts        = "OVERWRITE"
  service_account_role_arn = module.ebs_csi_role.iam_role_arn

  depends_on = [ module.eks.cluster_id ]
}

module "ebs_csi_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v4.7.0"
  create_role                   = true
  
  role_name                     = "${var.cluster_name}-ebs-csi-controller-sa"
  provider_url                  = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  role_policy_arns              = [aws_iam_policy.ebs_csi_role_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
  number_of_role_policy_arns    = 1
}

resource "aws_iam_policy" "ebs_csi_role_policy" {
  name        = "${var.cluster_name}_AmazonEKS_EBS_CSI_Driver_Policy"
  description = "EKS EBS CSI policy for ebs storage class"
  policy      = data.aws_iam_policy_document.ebs_csi.json
}

data "aws_iam_policy_document" "ebs_csi" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateTags"
    ]

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = [
        "CreateVolume",
        "CreateSnapshot"
      ]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:DeleteTags"
    ]

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateVolume"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateVolume"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values   = ["*"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateVolume",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }

statement {
    effect = "Allow"

    actions = [
      "ec2:DeleteVolume"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

statement {
    effect = "Allow"

    actions = [
      "ec2:DeleteVolume"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"
      values   = ["*"]
    }
  }

statement {
    effect = "Allow"

    actions = [
      "ec2:DeleteVolume"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "eResourceTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }

statement {
    effect = "Allow"

    actions = [
      "ec2:DeleteSnapshot"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values   = ["*"]
    }
  }

statement {
    effect = "Allow"

    actions = [
      "ec2:DeleteSnapshot"
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

}
