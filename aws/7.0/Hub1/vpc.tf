// AWS VPC 
resource "aws_vpc" "fgtvm-vpc" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name = "terraform SASE SD-WAN demo"
  }
}

resource "aws_subnet" "publicsubnetaz1wan1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.publiccidraz1wan1
  availability_zone = var.az1
  tags = {
    Name = "public subnet wan1 az1"
  }
}

resource "aws_subnet" "publicsubnetaz1wan2" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.publiccidraz1wan2
  availability_zone = var.az1
  tags = {
    Name = "public subnet wan2 az1"
  }
}

resource "aws_subnet" "privatesubnetaz1" {
  vpc_id            = aws_vpc.fgtvm-vpc.id
  cidr_block        = var.privatecidraz1
  availability_zone = var.az1
  tags = {
    Name = "private subnet az1"
  }
}
