resource "aws_ecs_service" "wordpress_ecs_service" {

  desired_count                     = var.ecs_service_desired_capacity
  iam_role                          = aws_iam_role.ecsServiceRole.name
  cluster                           = aws_ecs_cluster.wordpress_ecs_cluster.id
  health_check_grace_period_seconds = var.ecs_service_health_check_grace_period
  task_definition                   = aws_ecs_task_definition.wordpress_task_definition.arn
  name                              = "${var.project_name}-${var.environment_name}-service-${var.build_number}"

  load_balancer {
    container_port    = 80
    container_name    = "${var.project_name}-${var.environment_name}"
    target_group_arn  = aws_alb_target_group.wordpress_release_elb.arn
  }

}

resource "aws_appautoscaling_target" "ecs_cluster_target" {
  max_capacity       = var.ecs_autoscale_max_instance_size
  min_capacity       = var.ecs_autoscale_min_instance_size
  resource_id        = "service/${aws_ecs_cluster.wordpress_ecs_cluster.name}/${aws_ecs_service.wordpress_ecs_service.name}"
  role_arn           = data.aws_iam_role.ecsAutoscaleRole.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_cluster_autoscaling_down_policy" {

  name                    = "ContainersScaleDown"
  policy_type             = "StepScaling"
  resource_id             = "service/${aws_ecs_cluster.wordpress_ecs_cluster.name}/${aws_ecs_service.wordpress_ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_scaling_policy_configuration {
    cooldown                = 150
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [ aws_appautoscaling_target.ecs_cluster_target ]

}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_low_cpu_utilization" {

  alarm_name          = "${var.project_name}-${var.environment_name}-ECS-Low-CPU-Utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_ecs_autoscaling_group.name
  }

  alarm_actions = [ aws_appautoscaling_policy.ecs_cluster_autoscaling_down_policy.arn ]

}

resource "aws_appautoscaling_policy" "ecs_cluster_autoscaling_up_policy" {

  name                    = "ContainersScaleUp"
  policy_type             = "StepScaling"
  resource_id             = "service/${aws_ecs_cluster.wordpress_ecs_cluster.name}/${aws_ecs_service.wordpress_ecs_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 150
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment = 1
    }
  }

  depends_on = [ aws_appautoscaling_target.ecs_cluster_target ]

}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_high_cpu_utilization" {

  alarm_name          = "${var.project_name}-${var.environment_name}-ECS-High-CPU-Utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_ecs_autoscaling_group.name
  }

  alarm_actions = [ aws_appautoscaling_policy.ecs_cluster_autoscaling_up_policy.arn ]

}