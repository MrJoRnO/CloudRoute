terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" 
  
  cluster_name    = var.cluster_name
  cluster_version = "1.33" 


  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids


  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = null
  enable_cluster_creator_admin_permissions = true
  
  cluster_security_group_additional_rules = {
    ingress_admin_ip = {
      description = "Allow Runner IP to communicate with API Server"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [var.admin_ip] 
    }
  }
  
  eks_managed_node_groups = {
    main = {
      instance_types = var.instance_types 
      min_size       = 1
      max_size       = 5
      desired_size   = var.desired_size
    }
  }
}
resource "aws_iam_role_policy_attachment" "nodes_ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = module.eks.eks_managed_node_groups["main"].iam_role_name
  }
resource "aws_iam_role_policy_attachment" "additional_secrets" {
  policy_arn = var.secrets_policy_arn
  role       = module.eks.eks_managed_node_groups["main"].iam_role_name
}