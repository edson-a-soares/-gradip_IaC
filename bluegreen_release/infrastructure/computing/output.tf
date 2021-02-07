output "application_load_balancer_ard" {
  value = aws_lb.alb-ecs-cluster.arn
}
