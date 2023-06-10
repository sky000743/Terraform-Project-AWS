variable "ami_id" {
  description = " ami-0649a986224ded9da"
  type        = string
}

variable "instance_type" {
  description = "t2.medium"
  type        = string
}

variable "key_name" {
  description = "LaptopKey"
  type        = string
}

resource "aws_launch_template" "project" {
  name_prefix   = "terraform-project"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  
}

# Autoscaling group

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "aws_public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = ["subnet-public-1", "subnet-public-2", "subnet-public-3"]
}


variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 99
}

resource "aws_autoscaling_group" "Tfproject" {
  name                 = "Project-ASG"
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.min_size
  vpc_zone_identifier  = var.aws_private_subnets
  launch_template {
    id      = aws_launch_template.project.id
    version = "$Latest"
  }
}
