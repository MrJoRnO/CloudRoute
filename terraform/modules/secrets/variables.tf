variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "kms_key_description" {
  default = "KMS key for application secrets"
  type    = string
}

variable "tags" {
  type    = map(string)
  default = {}
}