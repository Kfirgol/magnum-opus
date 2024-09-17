resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"


  tags = {
    Name    = "commit-vpc"
    project = "commit-project"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "commit-public-1a"
    project = "commit-project"

  }
}


resource "aws_subnet" "public-1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.102.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true


  tags = {
    Name    = "commit-public-1b"
    project = "commit-project"

  }
}

resource "aws_security_group" "security_group" {
  name   = "commit-security-group"
  vpc_id = aws_vpc.vpc.id

  tags = {
    project = "commit-project"
  }

}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.vpc.id
  

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 80
    to_port    = 80
  }

  ingress = {
    protocol   = "http"
    rule_no    = 500
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 6443
    to_port    = 6443
  }

  tags = {
    Name    = "main"
    project = "commit-project"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "magnum-opus-rt"

  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "gw_association" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_lb" "eks-lb" {
  name               = "commit-eks-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]
  subnets            = [aws_subnet.public-1a.id, aws_subnet.public-1b.id]

  enable_deletion_protection = false


  tags = {
    Name = "commit-eks-lb"
    project = "commit-eks"
  }
}