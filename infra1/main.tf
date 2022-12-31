terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48"
    }
  }

  backend "s3" {
    bucket  = "my-terraform-state-werwerwe"
    key     = "global/tfstate/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    
  }
  
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

resource "aws_s3_bucket" "my_terraform_state_bucket" {
  bucket = "my-terraform-state-werwerwe"
}

resource "aws_s3_bucket_acl" "bucket_acl_1" {
  bucket = aws_s3_bucket.my_terraform_state_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning_1" {
  bucket = aws_s3_bucket.my_terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = "terraform-state-lock-dynamo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}