provider "aws" { region = "us-east-1" }
data "aws_availability_zones" "available" {}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

locals {
  n_subnets = length(data.aws_availability_zones.available.names)
  az_names  = data.aws_availability_zones.available.names

  # Single list comprehension to generate all subnets
  gen_subnet_cidrs = [for i in range(3 * local.n_subnets) : cidrsubnet(var.cidr_block, 8, i)]

  public_subnet_cidrs   = slice(local.gen_subnet_cidrs, 0 * local.n_subnets, 1 * local.n_subnets)
  private_subnet_cidrs  = slice(local.gen_subnet_cidrs, 1 * local.n_subnets, 2 * local.n_subnets)
  internal_subnet_cidrs = slice(local.gen_subnet_cidrs, 2 * local.n_subnets, 3 * local.n_subnets)

  public_subnets   = [for idx, az in local.az_names : { subnet_cidr = local.public_subnet_cidrs[idx], availability_zone = az }]
  private_subnets  = [for idx, az in local.az_names : { subnet_cidr = local.private_subnet_cidrs[idx], availability_zone = az }]
  internal_subnets = [for idx, az in local.az_names : { subnet_cidr = local.internal_subnet_cidrs[idx], availability_zone = az }]
}

module "tags" {
  source = "github.com/darvein/tf-tags?ref=v0.1"

  tags = {
    Environment = "Development"
    Customer = "ACME"
    Team     = "Nextbrave"
  }
}

module "vpc" {
  source     = "../"
  cidr_block = var.cidr_block

  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  internal_subnets = local.internal_subnets

  #tags = merge(local.common_tags, {
  tags = merge(module.tags.all, {
    Tier = "Network"
  })
}
