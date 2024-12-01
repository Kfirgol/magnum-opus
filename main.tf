module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = var.cluster-name
  cluster_version = "1.31"

  cluster_endpoint_public_access = false

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public-a.id, aws_subnet.public-b.id]
  eks_managed_node_group_defaults = {
    instance_types = ["t3.small"]
  }

  eks_managed_node_groups = {
    node_group = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  # enable_cluster_creator_admin_permissions = true

  access_entries = {
    viewer = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::590183844603:user/eks-user"
      policy_associations = {
        viewer = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
    root = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::590183844603:root"
      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
    github-runner = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::590183844603:user/github-runner"
      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }
}