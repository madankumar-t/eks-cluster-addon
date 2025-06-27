region          = "us-west-2"
cluster_name    = "my-eks"
node_group_name = "my-eks-ng"

subnet_ids      = ["subnet-abc123", "subnet-def456"]
cluster_version = "1.29"

desired_size   = 2
min_size       = 1
max_size       = 3
instance_types = ["t3.medium"]
ami_type       = "AL2_x86_64"
capacity_type  = "ON_DEMAND"
labels = {
  role = "worker"
}
tags = {
  Environment = "dev"
}
