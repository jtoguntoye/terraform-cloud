region = "eu-west-3"

vpc_cidr = "172.16.0.0/16"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

enable_dns_hostnames = "true"

enable_dns_support = "true"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 2

vpc_name = "main_vpc"

public_subnet_tag = "value"

eip_name = "nat_eip"

nat_gw = "nat_gw"

private-rtb-name = "kiff-rtb"

public-rtb-name = "kiff-pub-rtb"

ext-alb-sg-name = "kiff-ext-alb-sg"

ami =  "ami-0f7cd40eac2214b37"

keypair = "devops"

account_no = "384543527682"

tags = {
    Environment = "Dev"
    Owner-Email = "joeloguntoye@gmail.com"
    Managed-By  = "Terraform"
    Billing-Account = "384543527682"    
}

master_username = "joel"

master_password = "joel1234"