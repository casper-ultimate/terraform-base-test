resource "aws_instance" "host_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_size

  root_block_device {
    volume_size = var.instance_root_device_size
    volume_type = "gp3"
  }

  tags = {
    Name        = "wip-${var.infra_env}-host"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    Role = var.infra_role
  }
}

resource "aws_eip" "host_addr" {
  vpc = true
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "wip-${var.infra_env}-host-addr"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    Role = var.infra_role
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.host_instance.id
  allocation_id = aws_eip.host_addr.id
}