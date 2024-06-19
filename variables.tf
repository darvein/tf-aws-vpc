variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = object({
    # Technical Tags
    Name        = optional(string, "")
    Environment = string # Mandatory
    Application = optional(string, "")
    Tier        = optional(string, "")

    # Automation Tags
    Automated_Shutdown = optional(string, "")

    # Business Tags
    Customer = string # Mandatory
    Team     = optional(string, "")

    # Security Tags
    Confidentiality = optional(string, "")
  })

  default = {
    Name        = ""
    Environment = ""
    Application = ""
    Tier        = ""
    Automated_Shutdown = ""
    Customer = ""
    Team     = ""
    Confidentiality = ""
  }
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
