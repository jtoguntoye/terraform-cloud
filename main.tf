provider "aws" {
    region = "eu-west-3"
}

# create VPC
resource "aws_vpc" "main" {
    cidr_block = "172.16.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    enable_classiclink_dns_support = "false" 
}

# create public subnet1
resource "aws_subnet" "public1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "172.16.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-west-3a"
}

# create public subnet2
resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "172.16.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-west-3b"
}