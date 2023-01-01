#public security groups
resource "aws_security_group" "public_group" {
  name        = "wip-${var.infra_env}-public-sg"
  description = "Public internet access"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "wip-${var.infra_env}-public-sg"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    Role = "public"
  }
}

resource "aws_security_group_rule" "public_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_group.id
}

resource "aws_security_group_rule" "public_inbound_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_group.id
}

resource "aws_security_group_rule" "public_inbound_hhtp" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_group.id
}

resource "aws_security_group_rule" "public_inbound_hhtps" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_group.id
}

#Private Security Rules

resource "aws_security_group" "private_group" {
  name        = "wip-${var.infra_env}-private-sg"
  description = "private rule access"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "wip-${var.infra_env}-private-sg"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    Role = "private"
  }
}

resource "aws_security_group_rule" "private_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private_group.id
}

resource "aws_security_group_rule" "private_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.private_group.id
}