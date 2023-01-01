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