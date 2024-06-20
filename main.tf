resource "aws_vpc" "this" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = false
  assign_generated_ipv6_cidr_block = false
  #enable_classiclink               = false
  #enable_classiclink_dns_support   = false

  tags = merge(var.tags, 
    {
    "Name" = format("%s-%s-vpc", var.tags.Customer, var.tags.Environment) 
    }
  )
}

resource "aws_subnet" "public" {
  for_each = { for idx, subnet in var.public_subnets: idx => subnet }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.subnet_cidr
  availability_zone = each.value.availability_zone
  tags = merge(var.tags, { Name = format("%s-public", var.tags.Customer) }
  )
}

resource "aws_subnet" "private" {
  for_each = { for idx, subnet in var.private_subnets: idx => subnet }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.subnet_cidr
  availability_zone = each.value.availability_zone
  tags = merge(var.tags, { Name = format("%s-private", var.tags.Customer) }
  )
}

resource "aws_subnet" "internal" {
  for_each = { for idx, subnet in var.internal_subnets: idx => subnet }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.subnet_cidr
  availability_zone = each.value.availability_zone
  tags = merge(var.tags, { Name = format("%s-internal", var.tags.Customer) }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    "Name" = format("%s-%s-igw", var.tags.Customer, var.tags.Environment)
  })
}

resource "aws_eip" "nat_eips" {
  count = length(var.private_subnets)
  
  tags = var.tags
}

resource "aws_nat_gateway" "this" {
  count = length(var.private_subnets)

  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.tags, {
    "Name" = format("%s-%s-natgw", var.tags.Customer, var.tags.Environment)
  })

  depends_on = [aws_internet_gateway.this]
}
