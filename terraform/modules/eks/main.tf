module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0" # עדכון לגרסה 20 שתומכת ב-Providers החדשים
  providers = {
    kubernetes = kubernetes
  }
  cluster_name    = var.cluster_name
  cluster_version = "1.32" 

  # בגרסה 20 הפרמטרים מעט שונים:
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # אבטחת ה-API
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = [var.admin_ip]
  
  # הגדרת הגישה לקלאסטר (Access Entry) - חובה בגרסה 20
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    main = {
      instance_types = ["c7i-flex.large"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2

      ami_type = "AL2_x86_64"
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