# vpc/main.tf

resource "aws_vpc" "vtest" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "vtest-public-1" {
  vpc_id                  = aws_vpc.vtest.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.ZONE1
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "vtest-public-1"
  }
}

resource "aws_subnet" "vtest-public-2" {
  vpc_id                  = aws_vpc.vtest.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.ZONE2
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "vtest-public-2"
  }
}

resource "aws_subnet" "vtest-private-1" {
  vpc_id            = aws_vpc.vtest.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.ZONE1
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "vtest-private-1"
  }
}

resource "aws_subnet" "vtest-private-2" {
  vpc_id            = aws_vpc.vtest.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.ZONE2
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "vtest-private-2"
  }
}

resource "aws_internet_gateway" "vtest-IGW" {
  vpc_id = aws_vpc.vtest.id

  tags = {
    Name        = "vtest-IGW"
  }
}

resource "aws_route_table" "vtest-public-RT" {
  vpc_id = aws_vpc.vtest.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vtest-IGW.id
  }

  tags = {
    Name        = "vtest-public-RT"
  }
}


resource "aws_route_table_association" "vtest-public-1-a" {
  subnet_id      = aws_subnet.vtest-public-1.id
  route_table_id = aws_route_table.vtest-public-RT.id
}

resource "aws_route_table_association" "vtest-public-2-a" {
  subnet_id      = aws_subnet.vtest-public-2.id
  route_table_id = aws_route_table.vtest-public-RT.id
}
