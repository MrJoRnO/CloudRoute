# כתובת ה-API של הקלאסטר (חשוב לחיבור kubectl)
output "eks_cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API"
  value       = module.kubernetes.cluster_endpoint
}

# ה-ID של ה-VPC שנוצר
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

# האזור בו הוקמה התשתית
output "region" {
  value = var.region
}