resource "aws_db_subnet_group" "db-group" {
  name       = "db-group"
  subnet_ids = ["subnet-0435c577cae9fb93c", "subnet-0ae53beefe9a4072c", "subnet-09f0853d1af77fd08"]  # Update with your desired subnet IDs
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier      = "rds-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.2"
  database_name           = "projectdb"  # Update with a valid database name
  backup_retention_period = 7
  preferred_backup_window = "02:00-03:00"
  vpc_security_group_ids  = ["sg-0c5d83c6ef6dc40f9"]  # Update with your desired security group ID

  db_subnet_group_name = aws_db_subnet_group.db-group.name  # Update with the correct variable name

  tags = {
    Name = "rds-cluster"
  }
}



resource "aws_rds_cluster_instance" "writer" {
  count                 = 1
  identifier            = "wordpress-writer"
  cluster_identifier    = aws_rds_cluster.rds.id
  instance_class        = "db.t3.medium"  # Update with your desired instance type
  engine                = "aurora-mysql"
  engine_version        = "5.7.mysql_aurora.2.07.2"
  publicly_accessible   = false

  tags = {
    Name = "wordpress-writer"
  }
}

resource "aws_rds_cluster_instance" "reader" {
  count                 = 2
  identifier            = "wordpress-reader-${count.index}"
  cluster_identifier    = aws_rds_cluster.rds.id
  instance_class        = "db.t3.medium"  # Update with your desired instance type
  engine                = "aurora-mysql"
  engine_version        = "5.7.mysql_aurora.2.07.2"
  publicly_accessible   = false

  tags = {
    Name = "wordpress-reader-${count.index}"
  }
}