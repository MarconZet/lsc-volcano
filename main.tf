provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name = "availability-zone"
    values = ["us-east-1d", "us-east-1f"]
  }
}

locals {
  lab_role_arn = "arn:aws:iam::536953741475:role/LabRole"
}

module "eks" {
  source = "./terraform-aws-eks"

  cluster_name    = "volcano-cluster"
  cluster_version = "1.24"

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  kms_key_administrators = ["null"]
  cluster_encryption_config = []
  create_iam_role        = false
  iam_role_arn           = local.lab_role_arn

  eks_managed_node_group_defaults = {
    create_iam_role = false
    iam_role_arn    = local.lab_role_arn
  }

  eks_managed_node_groups = {
    blue = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }

  manage_aws_auth_configmap = true
  enable_irsa = false

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}