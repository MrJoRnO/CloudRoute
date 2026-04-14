module "github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "~> 5.0"
}

module "github_oidc_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "~> 5.0"

  name = "github-actions-eks-deployer"

  subjects = [
    "repo:MrJoRnO/CloudRoute:*"
  ]

  policies = {
    Admin = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}

resource "aws_eks_access_entry" "github_runner" {
  cluster_name      = module.kubernetes.cluster_name 
  principal_arn     = module.github_oidc_role.arn
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_runner_admin" {
  cluster_name  = module.kubernetes.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = module.github_oidc_role.arn

  access_scope {
    type = "cluster"
  }
}

resource "aws_security_group_rule" "allow_eks_api_public" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.kubernetes.cluster_security_group_id
  description       = "Allow public access to EKS API for GitHub OIDC"
}