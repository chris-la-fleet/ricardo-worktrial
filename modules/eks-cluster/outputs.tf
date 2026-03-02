output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64-encoded EKS cluster CA certificate"
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

output "cluster_version" {
  description = "Kubernetes version running in EKS"
  value       = aws_eks_cluster.this.version
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for EKS cluster"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  value       = aws_iam_openid_connect_provider.this.arn
}

output "node_role_arn" {
  description = "IAM role ARN used by EKS node groups"
  value       = aws_iam_role.node.arn
}

output "cluster_autoscaler_role_arn" {
  description = "IAM role ARN for the cluster-autoscaler service account"
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "vpc_id" {
  description = "VPC ID used by the cluster"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs used by node groups"
  value       = module.vpc.private_subnets
}
