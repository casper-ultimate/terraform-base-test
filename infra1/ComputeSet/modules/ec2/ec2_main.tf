resource "random_shuffle" "subnets" {
  input        = var.subnets
  result_count = 1
}

resource "aws_instance" "host_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_size

  root_block_device {
    volume_size = var.instance_root_device_size
    volume_type = "gp3"
  }

  subnet_id = random_shuffle.subnets.result[0]

  vpc_security_group_ids = var.security_groups

  tags = merge(
    {
      Name        = "wip-${var.infra_env}-host"
      Environment = var.infra_env
      ManagedBy   = "terraform"

      Role = var.infra_role
    },
    var.tags
  )

  user_data = var.user_data

}

resource "aws_eip" "host_addr" {
  count = (var.withElasticIp) ? 1 : 0

  vpc = true
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "wip-${var.infra_env}-host-addr"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    Role = var.infra_role
  }
}

resource "aws_eip_association" "eip_assoc" {
  count = (var.withElasticIp) ? 1 : 0

  instance_id   = aws_instance.host_instance.id
  allocation_id = aws_eip.host_addr[0].id
}