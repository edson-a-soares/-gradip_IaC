resource "aws_alb_target_group" "wordpress_release_elb" {

  port            = 80
  protocol        = "HTTP"
  target_type     = "instance"
  vpc_id          = data.aws_vpc.default.id
  name            = "${var.project_name}-${var.environment_name}-${var.build_number}"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "4"
    interval            = "30"
    matcher             = "200"
    path                = "/wp-admin/images/wordpress-logo.svg"
    protocol            = "HTTP"
    timeout             = "5"
  }

  depends_on = [ aws_lb.wordpress-release-alb-ecs ]

  tags = {
    Version = var.build_number
    Name    = "${var.project_name}-${var.environment_name}"
  }

}

resource "aws_lb" "wordpress-release-alb-ecs" {

  subnets         = var.subnets
  security_groups = [ aws_security_group.alb_security_group.id ]
  name            = "${var.project_name}-${var.environment_name}-${var.build_number}"

  tags = {
    Version = var.build_number
    Name    = "${var.project_name}-${var.environment_name}"
  }

}

resource "aws_alb_listener" "wordpress-release-listener" {

  port			    = 80
  protocol		    = "HTTP"
  load_balancer_arn = aws_lb.wordpress-release-alb-ecs.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.wordpress_release_elb.arn
  }

  depends_on = [
    aws_lb.wordpress-release-alb-ecs,
    aws_alb_target_group.wordpress_release_elb
  ]

}
