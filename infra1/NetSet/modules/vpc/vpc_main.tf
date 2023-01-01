resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "wip-${var.infra_env}-vpc"
    Environment = var.infra_env
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "public" {
  for_each   = var.public_subnet_map
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "wip-${var.infra_env}-public-subnet"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    Role   = "public"
    Subnet = "${each.key}-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each   = var.private_subnet_map
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "wip-${var.infra_env}-private-subnet"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    Role   = "private"
    Subnet = "${each.key}-${each.value}"
  }
}

#public route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#private route
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
}
