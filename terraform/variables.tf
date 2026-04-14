variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster and prefix for related resources"
  type        = string
  default     = "url-shortener-secure"
}

variable "admin_ip" {
  description = "Your public IP address in CIDR notation for API access"
  type        = string
  default     = "0.0.0.0/0"
}

