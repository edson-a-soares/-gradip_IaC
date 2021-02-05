resource "aws_autoscaling_group" "wordpress_ecs_autoscaling_group" {

  name             = "${var.project_name}-${var.environment_name}-ecs (${var.build_number})"
  desired_capacity = var.ec2_autoscaling_desired_capacity
  max_size         = var.ec2_autoscaling_max_instance_size
  min_size         = var.ec2_autoscaling_min_instance_size

  vpc_zone_identifier   = var.subnets

  health_check_type     = "ELB"
  termination_policies  = [ "OldestInstance" ]
  launch_configuration  = aws_launch_configuration.wordpress-ecs-launch-configuration.name

  tag {
    key = "Name"
    value = "${var.project_name}-${var.environment_name}-ecs-cluster (${var.build_number})"
    propagate_at_launch = true
  }

  tag {
    key = "Version"
    value = var.build_number
    propagate_at_launch = true
  }

}
