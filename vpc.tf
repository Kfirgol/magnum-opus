resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"


  tags = {
    Name    = "magnum-opus-vpc"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.101.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "magnum-opus-public-a"
  }
}


resource "aws_subnet" "public-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.102.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true


  tags = {
    Name    = "magnum-opus-public-b"
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
    Name = "magnum-opus-eks-rt"

  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "gw-association-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "gw-association-b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.rt.id
}
