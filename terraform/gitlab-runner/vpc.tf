# VPC
resource "aws_vpc" "gitlab_runner" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix_name}-vpc"
  }
}

# Subnet
resource "aws_subnet" "private" {
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  vpc_id                  = aws_vpc.gitlab_runner.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix_name}-vpc-subnet-a"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.gitlab_runner.id
  tags = {
    Name = "${var.prefix_name}-igw"
  }
}

# Security Groups
resource "aws_security_group" "gitlab_runner" {
  vpc_id = aws_vpc.gitlab_runner.id
  name   = "${var.prefix_name}-sg"

  tags = {
    Name = "${var.prefix_name}-sg"
  }
}

resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.gitlab_runner.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.gitlab_runner.id

  tags = {
    Name = "${var.prefix_name}-route-table"
  }
}

resource "aws_route" "example" {
  gateway_id             = aws_internet_gateway.default.id
  route_table_id         = aws_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.default.id
}
