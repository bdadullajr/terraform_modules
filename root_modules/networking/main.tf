#######################################################
#####     AWS PROVIDER				######
#######################################################

provider "aws" {
  region = "${var.aws_region}"
  access_key = ""
  secret_key = ""
}

#######################################################
#####     VIRTUAL PRIVATE CLOUD	                  #####
#######################################################

resource "aws_vpc" "iac_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "iac_vpc"
  }
}

#######################################################
######     DEFINE INTERNET GATEWAY     #####
#######################################################

resource "aws_internet_gateway" "iac_gateway" {
  vpc_id = "${aws_vpc.iac_vpc.id}"

  tags {
    Name = "iac_internet_gw"
  }
}

#######################################################
######     DEFINE ROUTE TABLE     #####
#######################################################

resource "aws_route_table" "iac_public" {
  vpc_id = "${aws_vpc.iac_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.iac_gateway.id}"
  }

  tags {
    Name = "iac_public_rt"
  }
}

#######################################################
#####     ASSIGN ROUTE TABLE TO PUBLIC SUBNET     #####
#######################################################

resource "aws_route_table_association" "iac_public" {
  subnet_id = "${aws_subnet.iac_public_subnet.id}"
  route_table_id = "${aws_route_table.iac_public.id}"
}

#######################################################
#####     NETWORK ADDRESS TRANSLATION ELASTIC IP ######
#######################################################

resource "aws_eip" "ngw_elastic_ip" {
  vpc  = true

  tags = {
    Name = "iac_ngw"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.ngw_elastic_ip.id}"
  subnet_id     = "${aws_subnet.iac_public_subnet.id}"
  depends_on    = ["aws_internet_gateway.iac_gateway"]

  tags {
    Name = "iac_nat"
  }
}

#######################################################
#####     PUBLIC SUBNET			          #####
#######################################################

resource "aws_subnet" "iac_public_subnet" {
  vpc_id = "${aws_vpc.iac_vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"

  tags {
    Name = "public_subnet"
  }
}

#######################################################
#####     PRIVATE SUBNET 	                  #####
#######################################################

resource "aws_subnet" "iac_private_subnet" {
  vpc_id = "${aws_vpc.iac_vpc.id}"
  cidr_block = "${var.private_subnet_cidr}"

  tags {
    Name = "private_subnet"
  }
}

#######################################################
#####     HTTP PORT				  #####
#######################################################

resource "aws_security_group" "iac_public_sg" {
  name        = "iac_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.iac_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.accessip}"]
  }
}

#######################################################
