resource "aws_alb_target_group" "alb" {

  port            = 80
  protocol        = "HTTP"
  target_type     = "instance"
  vpc_id          = var.vpc_id
  name            = "${var.project_name}-${var.environment_name}-v${var.build_number}"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "4"
    interval            = "30"
    matcher             = "304"
    path                = "/"
    protocol            = "HTTP"
    timeout             = "5"
  }

  depends_on = [ aws_lb.alb-ecs-cluster ]

  tags = {
    Version = var.build_number
    Name    = "${var.project_name}-${var.environment_name}-v${var.build_number}"
  }

}

resource "aws_lb" "alb-ecs-cluster" {

  subnets         = var.subnets
  security_groups = [ aws_security_group.alb_security_group.id ]
  name            = "${var.project_name}-${var.environment_name}-v${var.build_number}"

  tags = {
    Version = var.build_number
    Name    = "${var.project_name}-${var.environment_name}"
  }

}

resource "aws_alb_listener" "alb-release-listener" {

  port			    = 80
  protocol		    = "HTTP"
  load_balancer_arn = aws_lb.alb-ecs-cluster.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb.arn
  }

  depends_on = [
    aws_lb.alb-ecs-cluster,
    aws_alb_target_group.alb
  ]

}
