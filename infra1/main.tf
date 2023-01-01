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

data "aws_ami" "host" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"]
}


module "vpc" {
  source    = "./NetSet/modules/vpc"
  vpc_cidr  = "10.0.0.0/17"
  infra_env = var.infra_env
}

variable "instance_size" {
  type = string
}

module "experience_host" {
  source = "./ComputeSet/modules/ec2"

  infra_env  = var.infra_env
  infra_role = "web"

  instance_size = var.instance_size
  instance_ami  = data.aws_ami.host.id

  subnets         = keys(module.vpc.vpc_public_subnets)
  security_groups = [module.vpc.security_group_public]

  tags = {
    Name = "wip-${var.infra_env}-ec2-experience"
  }

  withElasticIp = true
}

module "worker_host" {
  source = "./ComputeSet/modules/ec2"

  infra_env  = var.infra_env
  infra_role = "worker"

  instance_size = var.instance_size
  instance_ami  = data.aws_ami.host.id

  subnets         = keys(module.vpc.vpc_private_subnets)
  security_groups = [module.vpc.security_group_private]

  tags = {
    Name = "wip-${var.infra_env}-ec2-worker"
  }

  withElasticIp = false
}