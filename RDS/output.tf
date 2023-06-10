output "db_subnet_group_name" {
  value = aws_db_subnet_group.db-group.name
}

output "rds_cluster_id" {
  value = aws_rds_cluster.rds.id
}

output "writer_instance_id" {
  value = aws_rds_cluster_instance.writer.*.id
}

output "reader_instance_ids" {
  value = aws_rds_cluster_instance.reader.*.id
}

output "writer_endpoint" {
  value = aws_route53_record.writer_endpoint.fqdn
}

output "reader1_endpoint" {
  value = aws_route53_record.reader1_endpoint.fqdn
}

output "reader2_endpoint" {
  value = aws_route53_record.reader2_endpoint.fqdn
}
