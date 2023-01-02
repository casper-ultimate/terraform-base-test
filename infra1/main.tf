terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
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

variable "public_subnets_a" {
  type = map(string)
}

variable "private_subnets_a" {
  type = map(string)
}

module "vpc" {
  source             = "./NetSet/modules/vpc"
  vpc_cidr           = "10.0.0.0/17"
  infra_env          = var.infra_env
  public_subnet_map  = var.public_subnets_a
  private_subnet_map = var.private_subnets_a
}

variable "instance_size" {
  type = string
}

module "experience_host" {
  source = "./ComputeSet/modules/ec2"

  infra_env  = var.infra_env
  infra_role = "web"

  instance_size = var.instance_size
  instance_ami  = "ami-0283a57753b18025b" #"ami-0a606d8395a538502"

  subnets         = keys(module.vpc.vpc_public_subnets)
  security_groups = [module.vpc.security_group_public]

  tags = {
    Name = "wip-${var.infra_env}-ec2-experience"
  }

  withElasticIp = true

  user_data = <<-EOF
              #!/bin/bash
              sudo echo "Hello, World" > index.html
              sudo nohup busybox httpd -f -p 80
              EOF
  
}

module "worker_host" {
  source = "./ComputeSet/modules/ec2"

  infra_env  = var.infra_env
  infra_role = "worker"

  instance_size = var.instance_size
  instance_ami  = "ami-0283a57753b18025b" #"ami-0a606d8395a538502"

  subnets         = keys(module.vpc.vpc_private_subnets)
  security_groups = [module.vpc.security_group_private]

  tags = {
    Name = "wip-${var.infra_env}-ec2-worker"
  }

  withElasticIp = false
}