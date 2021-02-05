resource "aws_vpc" "vpc" {
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr_block           = var.vpc_cidr
  tags = {
    Environment = var.environment_name
    Name        = "${var.project_name}-${var.environment_name}-${var.build_number}"
  }
}
