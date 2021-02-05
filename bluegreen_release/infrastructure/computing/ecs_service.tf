resource "aws_ecs_service" "ecs_service" {

  desired_count                     = var.ecs_service_desired_capacity
  iam_role                          = aws_iam_role.ecsServiceRole.name
  cluster                           = aws_ecs_cluster.ecs_cluster.id
  health_check_grace_period_seconds = var.ecs_service_health_check_grace_period
  task_definition                   = aws_ecs_task_definition.cluster_task_definition.arn
  name                              = "${var.project_name}-${var.environment_name}-service-v${var.build_number}"

  load_balancer {
    container_port    = 80
    target_group_arn  = aws_alb_target_group.alb.arn
    container_name    = "${var.project_name}-${var.environment_name}"
  }

}
