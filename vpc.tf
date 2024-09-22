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
    Name = "commit-eks-rt"

  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "gw_association" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.rt.id
}
