terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = {
    Project     = "terraform-eks"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

terraform {
  backend "s3" {
    bucket       = "suren-0797"
    key          = "eks/dev/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}


# module "vpc" {
#   source = "../../modules/vpc"

#   name                 = var.name
#   cluster_name         = var.cluster_name
#   vpc_cidr             = var.vpc_cidr
#   public_subnet_cidrs  = var.public_subnet_cidrs
#   private_subnet_cidrs = var.private_subnet_cidrs

#   tags = local.common_tags
# }

data "aws_vpc" "default" {
  default = true
}


data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "iam" {
  source = "../../modules/iam"

  cluster_name = var.cluster_name
  tags         = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  cluster_role_arn    = module.iam.cluster_role_arn
  node_role_arn       = module.iam.node_role_arn
  vpc_id = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids
  instance_types      = var.instance_types
  capacity_type       = var.capacity_type
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size

  tags = local.common_tags

  depends_on = [module.iam]
}
