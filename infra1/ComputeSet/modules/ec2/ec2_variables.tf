variable "infra_env" {
  type = string
}

variable "infra_role" {
  type        = string
  description = "infrastructure purpose"
}

variable "instance_size" {
  type        = string
  description = "ec2 web server size"
  default     = "t3.small"
}

variable "instance_ami" {
  type        = string
  description = "Server image to use"
}

variable "instance_root_device_size" {
  type        = number
  description = "Root block size in GB"
  default     = 12
}

variable "subnets" {
  type = list(string)

  description = "valid subnets to assign to host"
}

variable "security_groups" {
  type = list(string)

  description = "security groups to assign to host"
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "tags for the ec2 instance"
}

variable "withElasticIp" {
  type        = bool
  default     = false
  description = "whether to create an EIP for the host"
}