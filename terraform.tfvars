aws_region = "us-east-1"

tags = {
  application = "web"
  environment = "dev"
  owner       = "Aravind"
}

vpc_cidr_block       = "10.0.0.0/16"
vpc_instance_tenancy = "default"
enable_dns_support   = true
enable_dns_hostnames = true
public_subnet_cidr   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr  = ["10.0.101.0/24", "10.0.102.0/24"]