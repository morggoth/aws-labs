terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.61.0"
    }
  }
}

locals {
  common_tags = {
    LabName = var.lab_name
  }

}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "lab" {
  cidr_block = var.vpc_cidr_block

  tags = merge(
    { Name = "Lab VPC" },
    local.common_tags
  )
}

resource "aws_subnet" "public" {
  cidr_block        = var.subnet_cidr_public
  vpc_id            = aws_vpc.lab.id
  availability_zone = var.subnet_az

  map_public_ip_on_launch = var.subnet_auto_enable_public_ip

  tags = merge(
    { Name = "Public" },
    local.common_tags
  )
}

resource "aws_subnet" "private" {
  cidr_block        = var.subnet_cidr_private
  vpc_id            = aws_vpc.lab.id
  availability_zone = var.subnet_az

  tags = merge(
    { Name = "Private" },
    local.common_tags
  )
}

resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.lab.id

  tags = merge(
    { Name = "IGW" },
    local.common_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id
  route {
    cidr_block = var.rt_public_cidr_public
    gateway_id = aws_internet_gateway.main_gw.id
  }

  tags = merge(
    { Name = "Public" },
    local.common_tags
  )
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_security_group" "public" {
  name        = "public-subnet-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.lab.id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.sg_allow_ssh_cidr]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    { Name = "public-subnet-sg" },
    local.common_tags
  )
}

resource "aws_key_pair" "public" {
  key_name   = "${var.lab_name}-key-for-public-subnet"
  public_key = file("${path.module}/${var.key_public_path}.pub")

  tags = merge(
    { Name = "${var.lab_name}-key-for-public-subnet" },
    local.common_tags
  )
}

resource "aws_instance" "public" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.public.key_name
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = merge(
    { Name = "Public instance" },
    local.common_tags
  )
}