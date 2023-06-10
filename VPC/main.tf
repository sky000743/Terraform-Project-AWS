resource "aws_vpc" "project" {
  cidr_block = "10.0.0.0/16" 
   tags = {
    Name = "project"  
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public1"  
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.102.0/24"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "public2"  
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.103.0/24"
  availability_zone       = "us-east-1c"
  tags = {
    Name = "public3"  
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "private1"  
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "private2"  
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id                  = aws_vpc.project.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1c"
  tags = {
    Name = "private3"  
  }
}

resource "aws_internet_gateway" "public-igw" {
  vpc_id = aws_vpc.project.id
  tags ={
    Name = "public-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.project.id
}

resource "aws_route" "internet_gateway_route" {
  route_table_id            = aws_route_table.rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.public-igw.id
}
resource "aws_route" "custom_routes" {
  for_each          = var.routes
  route_table_id    = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id        = each.value.gateway_id
}

resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_vpc.project.default_route_table_id
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_vpc.project.default_route_table_id
}

resource "aws_route_table_association" "public_subnet_association_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_vpc.project.default_route_table_id
}

resource "aws_eip" "elip" {
  vpc = true
  tags = {
    Name = "elip"
  }
}

resource "aws_nat_gateway" "private-gw" {
  allocation_id = aws_eip.elip.id
  subnet_id     = aws_subnet.private_subnet_1.id
  tags = {
    Name = "nat-gw"
  }
}

resource "aws_security_group" "project_security_group" {
  name        = "MySecurityGroup"
  description = "My security group description"
  vpc_id      = aws_vpc.project.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from any IP
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from any IP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS access from any IP
  }
}