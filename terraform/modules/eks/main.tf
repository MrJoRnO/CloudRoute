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
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  enable_cluster_creator_admin_permissions = false


  eks_managed_node_groups = {
    main = {
      instance_types = var.instance_types 
      min_size       = 1
      max_size       = 5
      desired_size   = var.desired_size
    }
  }
  node_security_group_additional_rules = {
  ingress_allow_nlb_traffic = {
    description      = "Allow traffic from NLB to Nodes"
    protocol         = "tcp"
    from_port        = 0     
    to_port          = 65535
    type             = "ingress"
    cidr_blocks      = ["0.0.0.0/0"] 
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