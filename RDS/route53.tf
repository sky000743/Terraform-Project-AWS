resource "aws_route53_record" "writer_endpoint" {
  zone_id = "Z075058929SGSID3FFSI6"  # Update with your Route 53 zone ID
  name    = "writer.devops312.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster_instance.writer[0].endpoint]
}

resource "aws_route53_record" "reader1_endpoint" {
  zone_id = "Z075058929SGSID3FFSI6"  # Update with your Route 53 zone ID
  name    = "reader1.devops312.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster_instance.reader[0].endpoint]
}

resource "aws_route53_record" "reader2_endpoint" {
  zone_id = "Z075058929SGSID3FFSI6"  # Update with your Route 53 zone ID
  name    = "reader2.devops312.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster_instance.reader[1].endpoint]
}