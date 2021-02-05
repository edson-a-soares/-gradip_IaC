# Routing table for the private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Environment = var.environment_name
    Name        = "${var.project_name}-${var.environment_name}-v${var.build_number}-private"
  }
}

# Routing table for the public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Environment = var.environment_name
    Name        = "${var.project_name}-${var.environment_name}-v${var.build_number}-public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

# Route table associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  route_table_id = aws_route_table.private.id
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
}
