data "template_file" "container_template" {

  template = file("${path.module}/templates/container-definition.json")

  vars = {
    image                 = var.docker_image
    cpu                   = var.container_cpu
    memory                = var.container_memory
    version               = var.docker_image_version
    container_name        = "${var.project_name}-${var.environment_name}"
  }

}

resource "aws_ecs_task_definition" "cluster_task_definition" {

  lifecycle {
    create_before_destroy = true
  }

  container_definitions = data.template_file.container_template.rendered
  family                = "${var.project_name}-${var.environment_name}-v${var.build_number}"

}
