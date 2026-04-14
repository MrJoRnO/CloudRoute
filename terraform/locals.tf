locals {
  common_tags = {
    Project     = "URL-Shortener"
    Environment = "Staging"
    ManagedBy   = "Terraform"
    Owner       = "Noam"
  }
  # (stage or prod)
  env = terraform.workspace

  prefix = "url-shortener-${local.env}"
  
  node_config = {
    stage = {
      instance_types = ["c7i-flex.large"]
      desired_size   = 1
    }
    prod = {
      instance_types = ["c7i-flex.large"]
      desired_size   = 3
    }
  }
  current_nodes = local.node_config[local.env]
}