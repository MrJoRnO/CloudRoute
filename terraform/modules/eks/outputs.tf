output "cluster_endpoint" {
  description = "The endpoint for the Kubernetes API"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_security_group_id" {
  description = "The security group ID associated with the cluster control plane"
  value       = module.eks.cluster_security_group_id
}