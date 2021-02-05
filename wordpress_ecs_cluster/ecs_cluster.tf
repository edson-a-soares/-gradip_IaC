resource "aws_ecs_cluster" "wordpress_ecs_cluster" {
  name = "${var.project_name}-${var.environment_name}-${var.build_number}"
}
