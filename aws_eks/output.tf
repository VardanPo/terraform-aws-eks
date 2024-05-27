output "name" {
  value = aws_eks_cluster.main_cluster.name
}
output "id" {
  value = aws_eks_cluster.main_cluster.id
}
output "arn" {
  value = aws_eks_cluster.main_cluster.arn
}
output "version" {
  value = aws_eks_cluster.main_cluster.version
}
output "certificate_authority" {
  value = aws_eks_cluster.main_cluster.certificate_authority
}
output "endpoint" {
  value = aws_eks_cluster.main_cluster.endpoint
}