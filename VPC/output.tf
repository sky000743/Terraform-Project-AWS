output "vpc_id" {
  value = aws_vpc.project.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.public_subnet_3.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id
  ]
}

output "security_group_id" {
  value = aws_security_group.project_security_group.id
}
# Output the internet gateway ID
output "internet_gateway_id" {
  value = aws_internet_gateway.public-igw.id
}

# Output the route table ID
output "route_table_id" {
  value = aws_route_table.rt.id
}