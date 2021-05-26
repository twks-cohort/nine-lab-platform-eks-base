locals {
  cloud_watch_agents_account_namespace     = "amazon-cloudwatch"
  cloud_watch_agents_service_account_name  = "${var.cluster_name}-cloudwatch-agent"
}

#cloudwatch-agents
module "iam_assumable_role_cloudwatch" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.1.0"

  create_role                   = true
  role_name                     = "${var.cluster_name}-cloudwatch-agent"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cloud_watch.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.cloud_watch_agents_account_namespace}:${local.cloud_watch_agents_service_account_name}"]
  number_of_role_policy_arns    = 1
}

resource "aws_iam_policy" "cloud_watch" {
  name_prefix = "${var.cluster_name}-cloud-watch"
  description = "EKS cloud_watch policy for the ${var.cluster_name} cluster"
  policy      = data.aws_iam_policy_document.cloud_watch.json
}

data "aws_iam_policy_document" "cloud_watch" {
  statement {
    sid    = "${var.cluster_name}CloudWatchSources"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "${var.cluster_name}CloudWatchSSM"
    effect = "Allow"

    actions = [
      "ssm:GetParameter"
    ]

    resources = ["arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"]
  }
}
