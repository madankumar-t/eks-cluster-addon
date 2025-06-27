provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  subnet_ids      = var.subnet_ids
  cluster_version = var.cluster_version
  tags            = var.tags

  eks_addons = {
    vpc-cni = {
      addon_version = "v1.16.1-eksbuild.1"
    }
    kube-proxy = {
      addon_version = "v1.29.0-eksbuild.1"
    }
    coredns = {
      addon_version = "v1.11.1-eksbuild.1"
    }
  }
}

module "nodegroup" {
  source = "./modules/nodegroup"

  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = module.eks.node_role_arn
  subnet_ids      = var.subnet_ids

  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
  instance_types  = var.instance_types
  ami_type        = var.ami_type
  capacity_type   = var.capacity_type
  labels          = var.labels
  tags            = var.tags
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = module.eks.cluster_role_arn
        username = "admin"
        groups   = ["system:masters"]
      },
      {
        rolearn  = module.eks.node_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
  }

  depends_on = [module.eks]
}
