variable "cidr_block" {
  description = "10.0.0.0/16"
  type        = string
  default     = "10.0.0.0/16"
}
variable "region" {
  description = "us-east-1"
  type        = string
}
variable "public_subnet1" {
  description = "10.0.1.0/24"
  type        = string
  default     = "10.0.1.0/24"
}
variable "public_subnet2" {
  description = "10.0.2.0/24"
  type        = string
  default     = "10.0.2.0/24"
}
variable "public_subnet3" {
  description = "10.0.3.0/24"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet1" {
  description = "10.0.101.0/24"
  type        = string
  default     = "10.0.101.0/24"
}
variable "private_subnet2" {
  description = "10.0.102.0/24"
  type        = string
  default     = "10.0.102.0/24"
}
variable "private_subnet3" {
  description = "10.0.103.0/24"
  type        = string
  default     = "10.0.103.0/24"
}