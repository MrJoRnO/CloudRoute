provider "aws" {
  region = var.region
}

# קריאה למודול הרשת המקומי
module "network" {
  source = "./modules/vpc"

  vpc_name           = "${var.cluster_name}-vpc"
  vpc_cidr           = var.vpc_cidr
  availability_zones = ["${var.region}a", "${var.region}b"]
  private_subnets    = var.private_subnet_cidrs
  public_subnets     = var.public_subnet_cidrs
}

module "ecr" {
  source = "./modules/ecr"
}
module "app_secrets" {
  source      = "./modules/secrets"
  secret_name = "${var.cluster_name}-db-pass"
  tags        = local.common_tags
}
module "kubernetes" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.private_subnets
  admin_ip     = var.admin_ip
  secrets_policy_arn = module.app_secrets.policy_arn
}