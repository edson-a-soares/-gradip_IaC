resource "aws_security_group" "nat" {

  description = "Allow traffic between private subnet and the internet."
  name = "${var.project_name}-${var.environment_name}-v${var.build_number}-NAT"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.vpc_cidr ]
  }

  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.vpc.id

}

resource "aws_security_group_rule" "http" {
  from_port         = 80
  to_port           = 80
  description       = ""
  protocol          = "tcp"
  type              = "ingress"
  count = length(var.private_subnets_cidr)
  security_group_id = aws_security_group.nat.id
  cidr_blocks = [ element(var.private_subnets_cidr, count.index) ]
}

resource "aws_security_group_rule" "https" {
  from_port         = 443
  to_port           = 443
  description       = ""
  protocol          = "tcp"
  type              = "ingress"
  count = length(var.private_subnets_cidr)
  security_group_id = aws_security_group.nat.id
  cidr_blocks = [ element(var.private_subnets_cidr, count.index) ]
}
