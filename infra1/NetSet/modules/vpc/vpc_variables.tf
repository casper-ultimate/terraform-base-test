variable "infra_env" {
  type = string

  description = "infrastructure environment"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string

  description = "The IP range to use for the vpc"
}

variable "public_subnet_map" {
  default = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    "us-east-1c" = 3
  }

  type = map(number)

  description = "Map of AZ to a number that should be used for public subnets"
}

variable "private_subnet_map" {
  default = {
    "us-east-1d" = 4
    "us-east-1e" = 5
    "us-east-1f" = 6
  }

  type = map(number)

  description = "Map of AZ to a number that should be used for private subnets"
}
