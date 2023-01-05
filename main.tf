provider "aws" {
  region = "eu-central-1"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "volcano-cluster"
  cluster_version = "1.24"

  cluster_endpoint_public_access  = true

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

  vpc_id                   = "vpc-08e567a69b0fd3d96"
  subnet_ids               = ["subnet-08432fd4b07230071", "subnet-0d36f59dc3bb36f14", "subnet-08432fd4b07230071"]

  eks_managed_node_groups = {
    blue = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
    }
  }

  manage_aws_auth_configmap = true

#  fargate_profiles = {
#    default = {
#      name = "default"
#      selectors = [
#        {
#          namespace = "default"
#        }
#      ]
#    }
#  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}