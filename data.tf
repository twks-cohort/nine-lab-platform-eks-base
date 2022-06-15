data "aws_vpc" "cluster_vpc" {
  tags = {
    cluster = var.cluster_name
  }
}

# data "aws_subnet_ids" "private" {
#   vpc_id = data.aws_vpc.cluster_vpc.id

#   tags = {
#     Tier = "private"
#   }
# }

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cluster_vpc.id]
  }

  tags = {
    Tier = "private"
  }
}

# data "aws_subnet" "private_subnetes" {
#   for_each = toset(data.aws_subnets.private.ids)
#   id       = each.value
# }

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_id
# }
