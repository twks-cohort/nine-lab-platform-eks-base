data "aws_vpc" "cluster_vpc" {
  tags = {
    cluster = var.cluster_name
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cluster_vpc.id]
  }

  tags = {
    Tier = "private"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
