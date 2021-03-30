resource "aws_security_group" "alb_security_group" {

  name   = "${var.project_name}-${var.environment_name}-alb"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "alb_security_group_ecs_instance_egress" {

  from_port                = 0
  protocol                 = "tcp"
  to_port                  = 65535
  type                     = "egress"
  security_group_id        = aws_security_group.alb_security_group.id
  source_security_group_id = aws_security_group.http_security_group.id

}

resource "aws_security_group" "http_security_group" {

  vpc_id  = data.aws_vpc.default.id
  name    = "${var.project_name}-${var.environment_name}-http"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_groups = [ aws_security_group.alb_security_group.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "database_security_group" {

  vpc_id  = data.aws_vpc.default.id
  name    = "${var.project_name}-${var.environment_name}-rds"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "ecs_instance_rds_egress" {
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  type                     = "egress"
  security_group_id        = aws_security_group.http_security_group.id
  source_security_group_id = aws_security_group.database_security_group.id
}
