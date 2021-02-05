resource "aws_appautoscaling_target" "ecs_cluster_target" {
  max_capacity       = var.ecs_autoscaling_max_instance_size
  min_capacity       = var.ecs_autoscaling_min_instance_size
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  role_arn           = data.aws_iam_role.ecsAutoscaleRole.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_cluster_autoscaling_down_policy" {

  name                    = "ContainersScaleDown"
  policy_type             = "StepScaling"
  resource_id             = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
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
    AutoScalingGroupName = aws_autoscaling_group.ecs_autoscaling_group.name
  }

  alarm_actions = [ aws_appautoscaling_policy.ecs_cluster_autoscaling_down_policy.arn ]

}

resource "aws_appautoscaling_policy" "ecs_cluster_autoscaling_up_policy" {

  name                    = "ContainersScaleUp"
  policy_type             = "StepScaling"
  resource_id             = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
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
    AutoScalingGroupName = aws_autoscaling_group.ecs_autoscaling_group.name
  }

  alarm_actions = [ aws_appautoscaling_policy.ecs_cluster_autoscaling_up_policy.arn ]

}