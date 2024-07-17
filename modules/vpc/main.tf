locals {
  az_count = var.tags.environment == "prod" ? 3 : 1
  #  az_ids   = slice(lookup(var.regional_az_maps, var.aws_region), 0, locals.az_count)
  az_ids = slice(data.aws_availability_zones.available.id, 0, 2)
}

#VPC
resource "aws_vpc" "main" {
  cidr_block         = var.vpc_cidr_block
  instance_tenancy   = var.vpc_instance_tenancy
  enable_dns_support = true
  tags               = var.tags
}
#Subnets
resource "aws_subnet" "public_subnet" {
  count                   = length(local.az_count)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = local.az_ids[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  count             = length(local.az_count)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = local.az_ids[count.index]
}

#IGW
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_vpc.main, aws_subnet.public_subnet]

  tags = var.tags

}

#NGW
resource "aws_eip" "nat_gateway_ip" {
  domain = vpc
  tags   = var.tags
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_ip
  subnet_id     = element(aws_subnet.public_subnet[*].id, 0)
  tags          = var.tags
}

#RouteTables && RouteTableAssociation

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw
  }
  tags = var.tags
}

resource "aws_route_table_association" "public-rta" {
  route_table_id = aws_route_table.public_rt.id
  count          = length(aws_subnet.public_subnet[*].id)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway
  }
  tags = var.tags
}

resource "aws_route_table_association" "private-rta" {
  route_table_id = aws_route_table.private_rt
  count          = length(aws_subnet.private_subnet[*].id)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
}
