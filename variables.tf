variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks"
  type        = list(object({
    subnet_cidr        = string
    availability_zone  = string
  }))
}

variable "private_subnets" {
  description = "A list of private subnet CIDR blocks"
  type        = list(object({
    subnet_cidr        = string
    availability_zone  = string
  }))
}

variable "internal_subnets" {
  description = "A list of internal subnet CIDR blocks"
  type        = list(object({
    subnet_cidr        = string
    availability_zone  = string
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
  default = {}
}
