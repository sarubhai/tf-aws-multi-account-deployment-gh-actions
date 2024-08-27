# Name: main.tf
# Owner: Saurav Mitra
# Description: This terraform configuration will Provision VPC & Subnets
# Infrastructure resources deployed in Multiple AWS Accounts using Github Actions CI/CD

# Terraform Version
terraform {
  required_version = ">= 1.9.5"
}

# Terraform Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }
}

# Provider Configuration
provider "aws" {
  region = "eu-central-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_env_account}:role/terraform-env-role"
  }
}

# Terraform Backend
terraform {
  backend "s3" {
    region  = "eu-central-1"
    key     = "terraform.tfstate"
    acl     = "private"
    encrypt = true
  }
}


# Variables
variable "environment" {
  description = "This environment tag will be included in the environment of the resources."
  default     = "dev"
}

variable "aws_env_account" {
  description = "The AWS environment account to provision the resources."
  default     = "777777777777"
}

variable "vpc_cidr_block" {
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "A map of availability zones to CIDR blocks to use for the public subnet."
  default = {
    eu-central-1a = "10.0.4.0/24"
    eu-central-1b = "10.0.5.0/24"
    eu-central-1c = "10.0.6.0/24"
  }
}


# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(values(var.public_subnets), count.index)
  availability_zone       = element(keys(var.public_subnets), count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-public-subnet-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = length(var.public_subnets)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}
