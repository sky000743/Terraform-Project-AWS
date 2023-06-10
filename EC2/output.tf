# Output the connection details
output "rds_endpoint" {
  value = aws_rds_cluster.rds.endpoint
}

output "rds_username" {
  value = aws_rds_cluster.rds.master_username
}

output "rds_password" {
  value = aws_rds_cluster.rds.master_password
}

output "wordpress_public_ip" {
  value = aws_instance.web1.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.web1.private_ip
}