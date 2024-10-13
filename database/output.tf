# database/outputs.tf

output "cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.aurora.endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "cluster_id" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.aurora.id
}

output "secondary_cluster_endpoint" {
  description = "The secondary cluster endpoint"
  value       = aws_rds_cluster.secondary.endpoint
}

output "secondary_cluster_reader_endpoint" {
  description = "The secondary cluster reader endpoint"
  value       = aws_rds_cluster.secondary.reader_endpoint
}

output "secondary_cluster_id" {
  description = "The ID of the secondary cluster"
  value       = aws_rds_cluster.secondary.id
}