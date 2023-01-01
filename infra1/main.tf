terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# resource "aws_dynamodb_table" "dynamodb_table_lock_resource" {
#   name         = "dynamo_state_lock_db"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

variable "infra_env" {
  type = string
}

# variable "vpc_cidr" {
#   default = "10.0.0.0/16"
#   type    = string

#   description = "The IP range to use for the vpc"
# }

module "vpc" {
  source    = "./NetSet/modules/vpc"
  vpc_cidr  = "10.0.0.0/17"
  infra_env = var.infra_env
}