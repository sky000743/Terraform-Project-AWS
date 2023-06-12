resource "aws_vpc" "Project" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Project"
  }
}


resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.Project.id
  cidr_block              = var.public_subnet1
  map_public_ip_on_launch = true
  tags = {
    Name = "Public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.Project.id
  cidr_block              = var.public_subnet2
  map_public_ip_on_launch = true
  tags = {
    Name = "Public2"
  }
}

resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.Project.id
  cidr_block              = var.public_subnet3
  map_public_ip_on_launch = true
  tags = {
    Name = "Public3"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.Project.id
  cidr_block              = var.private_subnet1
  map_public_ip_on_launch = false
  tags = {
    Name = "Private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.Project.id
  cidr_block              = var.private_subnet2
  map_public_ip_on_launch = false
  tags = {
    Name = "Private2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.Project.id
  cidr_block              = var.private_subnet3
  map_public_ip_on_launch = false
  tags = {
    Name = "Private3"
  }
}

resource "aws_internet_gateway" "ProjectIGW" {
  vpc_id = aws_vpc.Project.id

  tags = {
    Name = "ProjectIGW"
  }
}

# Attach Internet Gateway to Public Subnets
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.Project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ProjectIGW.id
  }

  tags = {
    Name = "RouteIG"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

# Create NAT Gateway
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.Projecteip.id
  subnet_id     = aws_subnet.public1.id

   tags = {
    Name = "NATGW"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "Projecteip" {
  vpc = true

  tags = {
    Name = "ProjectEIP"
  }
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private_subnet_rt" {
  vpc_id = aws_vpc.Project.id

  tags = {
    Name = "RouteNG"
  }
}

# Add Route for NAT Gateway to Private Subnets
resource "aws_route" "private_subnet_route" {
  route_table_id            = aws_route_table.private_subnet_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.NATgw.id
}

# Associate Private Subnets with Route Table
resource "aws_route_table_association" "Private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_subnet_rt.id
}

resource "aws_route_table_association" "Private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_subnet_rt.id
}

resource "aws_route_table_association" "Private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private_subnet_rt.id
}