
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

# קריאה למודול ה-EKS המקומי
module "kubernetes" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  # החיבור הקריטי: לוקח את הפלט של מודול הרשת ומעביר אותו לקלאסטר
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.private_subnets
  admin_ip     = var.admin_ip
}