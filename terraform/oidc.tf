
module "github_oidc_role" {
  count   = terraform.workspace == "stage" ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "~> 5.0"

  name = "github-actions-eks-deployer"
  subjects = ["repo:MrJoRnO/CloudRoute:*"]
  policies = {
    Admin = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}

data "aws_iam_role" "github_role" {
  name = "github-actions-eks-deployer"
  
  depends_on = [module.github_oidc_role]
}

resource "aws_eks_access_entry" "github_runner" {
  cluster_name      = module.kubernetes.cluster_name 
  principal_arn     = data.aws_iam_role.github_role.arn # שינוי כאן
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_runner_admin" {
  cluster_name  = module.kubernetes.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_role.github_role.arn 

  access_scope {
    type = "cluster"
  }
}