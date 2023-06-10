output "wordpress_public_ip" {
  value = aws_instance.project.public_ip
}