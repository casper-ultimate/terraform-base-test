#IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "wip-${var.infra_env}-vpc-igw"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    VPC = aws_vpc.vpc.id
  }
}

resource "aws_eip" "nat" {
  vpc = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = "wip-${var.infra_env}-vpc-eip"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    VPC  = aws_vpc.vpc.id
    Role = "private"
  }
}

# NAT (NGW)
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public[element(keys(aws_subnet.public), 0)].id

  tags = {
    Name        = "wip-${var.infra_env}-vpc-ngw"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    VPC  = aws_vpc.vpc.id
    Role = "private"
  }
}

#route tables and routes
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "wip-${var.infra_env}-vpc-rt-public"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    VPC  = aws_vpc.vpc.id
    Role = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "wip-${var.infra_env}-vpc-rt-private"
    Environment = var.infra_env
    ManagedBy   = "terraform"

    VPC  = aws_vpc.vpc.id
    Role = "private"
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id

  for_each  = aws_subnet.public
  subnet_id = aws_subnet.public[each.key].id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id

  for_each  = aws_subnet.private
  subnet_id = aws_subnet.private[each.key].id
}
