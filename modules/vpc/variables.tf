variable "tags" {
  type = map(string)
  validation {
    condition = (contains(keys(var.tags), "Name") &&
      contains(keys(var.tags), "Environment") &&
      contains(keys(var.tags), "Project") &&
      var.tags["Name"] != "" &&
      var.tags["Environment"] != "" &&
    var.tags["Project"] != "")
    error_message = "The tags map must contain the following keys: Name, Environment, Project."
  }
}

variable "aws_region" {
  description = "aws region"
  type        = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_instance_tenancy" {
  description = "Is the instance tenancy default or dedicated"
  type        = string
  validation {
    condition     = contains(["default", "dedicated"], var.vpc_instance_tenancy)
    error_message = "The VPC tenancy variable must be one of: default, dedicated."
  }
}

variable "enable_dns_support" {
  description = "enable dns support for VPC. This will set the DHCP_Hostnames"
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "sets dns names for ec2 instances like <ipaddress>.ec2.amazon.com"
  type        = bool
}

#variable "regional_az_maps" {
#  description = "Approved regions and their associated AZs"
#  type        = map(list(string))
#  default = {
#    "us-east-1" = ["use1-az1", "use1-az2"]
#    "us-west-1" = ["usw1-az1", "usw1-az2"]
#  }
#}

variable "public_subnet_cidr" {
  description = "CIDRs for public subnet"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "CIDRs for private subnet"
  type        = list(string)
}