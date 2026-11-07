aws_region   = "ap-south-1"
name         = "dev-eks"
cluster_name = "dev-eks"

# Verify this EKS version is supported in your AWS region before applying.
cluster_version = "1.33"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

# For learning this is simple, but restrict this to YOUR_PUBLIC_IP/32
# before using the cluster seriously.
public_access_cidrs = [
  "0.0.0.0/0"
]

instance_types = ["t3.medium"]
capacity_type  = "ON_DEMAND"

desired_size = 2
min_size     = 1
max_size     = 3
