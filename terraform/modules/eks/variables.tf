variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the worker nodes"
  type        = list(string)
}

variable "admin_ip" {
  description = "The public IP CIDR allowed to access the EKS API"
  type        = string
}

variable "secrets_policy_arn" {
  description = "The ARN of the IAM policy for secrets access"
  type        = string
  default     = null
}
variable "instance_types" {
  type    = list(string)
}

variable "desired_size" {
  type    = number
}