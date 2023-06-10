variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "domain_name" {
  description = "Domain name for the ALB"
  type        = string
}

resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress"
  image_id      = "ami-0649a986224ded9da"
  instance_type = "t2.medium"

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wordpress"
    }
  }
}

resource "aws_autoscaling_group" "wordpress" {
  name                 = "wordpress-asg"
  desired_capacity     = 1
  min_size             = 1
  max_size             = 99
  vpc_zone_identifier  = var.subnets

  launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }
}

resource "aws_lb" "wordpress" {
  name               = "wordpress-alb"
  load_balancer_type = "application"
  subnets            = var.subnets

  access_logs {
    bucket = "my-alb-logs-bucket"
  }

  tags = {
    Name = "wordpress-alb"
  }
}

resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }
}

resource "aws_lb_target_group" "wordpress" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/health"
  }
}

resource "aws_route53_record" "wordpress" {
  zone_id = "my-hosted-zone-id"
  name    = "wordpress.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.wordpress.dns_name
    zone_id                = aws_lb.wordpress.zone_id
    evaluate_target_health = true
  }
}
