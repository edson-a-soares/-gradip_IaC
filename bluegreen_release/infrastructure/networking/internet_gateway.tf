resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Environment = var.environment_name
    Name        = "${var.project_name}-${var.environment_name}-${var.build_number}"
  }
}
