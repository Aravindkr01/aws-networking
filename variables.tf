variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    "application" = "web"
    "environment" = "dev"
    "owner"       = "Aravind"
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_instance_tenancy" {
  description = "Is the instance tenancy default or dedicated"
  type        = string
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated"], var.vpc_instance_tenancy)
    error_message = "The VPC tenancy variable must be one of: default, dedicated."
  }
}

variable "enable_dns_support" {
  description = "enable dns support for VPC. This will set the DHCP_Hostnames"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "sets dns names for ec2 instances like <ipaddress>.ec2.amazon.com"
  type        = bool
  default     = true
}

variable "public_subnet_cidr" {
  description = "CIDRs for public subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDRs for private subnet"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

