variable "routes" {
  type = map(object({
    destination_cidr_block = string
    gateway_id             = string
  }))
  default = {
    "0.0.0.0/0" = {
      destination_cidr_block = "0.0.0.0/0"
      gateway_id             = aws_internet_gateway.public-igw.id
    }
    # Add more routes as needed
  }
}