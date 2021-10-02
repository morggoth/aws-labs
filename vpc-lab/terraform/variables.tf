# Common
variable "aws_region" {
  type        = string
  description = "Default region for AWS provider"
}
variable "lab_name" {
  type        = string
  description = "Name of current lab"
  default     = "vpc-lab"
}

# VPC
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for our VPC"
}

# Subnet
variable "subnet_cidr_public" {
  type        = string
  description = "CIDR block for a public subnet"
}
variable "subnet_cidr_private" {
  type        = string
  description = "CIDR block for a private subnet"
}
variable "subnet_az" {
  type        = string
  description = "AZ for subnets"
}
variable "subnet_auto_enable_public_ip" {
  type        = bool
  description = "Is enable auto-assign public IPv4 for launched instances"
  default     = true
}

# Route tables
variable "rt_public_cidr_public" {
  type        = string
  description = "Public CIDR block for a public route table"
}

# Security group
variable "sg_allow_ssh_cidr" {
  type        = string
  description = "CIDR block for a SSH allow rule"
}

# Key-pair
variable "key_public_path" {
  type        = string
  description = "Path to a private SSH-key for a Public subnet instances, relative to the module's directory"
  default     = "files/vpc-lab-public"
}
variable "key_private_path" {
  type        = string
  description = "Path to a private SSH-key for a Private subnet instances, relative to the module's directory"
  default     = "files/vpc-lab-private"
}

# EC2 instance
variable "ec2_ami" {
  type        = string
  description = "AMI for an EC2 instance"
}
variable "ec2_instance_type" {
  type        = string
  description = "Type of an instance"
  default     = "t2.micro"
}