resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.environment_name}-v${var.build_number}"
}
