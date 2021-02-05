data "template_file" "wordpress_container_template" {

  template = file("container-definition.json")

  vars = {
    image                 = var.docker_image
    cpu                   = var.container_cpu
    memory                = var.container_memory
    version               = var.docker_image_version
    container_name        = "${var.project_name}-${var.environment_name}"

    wp_database_name      = var.database_name
    wp_database_user      = var.database_username
    wp_database_password  = var.database_password
    wp_table_prefix       = var.wordpress_table_prefix
    wp_database_host      = aws_db_instance.wordpress.address
  }

  depends_on = [ aws_db_instance.wordpress ]

}

resource "aws_ecs_task_definition" "wordpress_task_definition" {

  lifecycle {
    create_before_destroy = true
  }

  volume {
    name = "www-data"
  }

  family                = "${var.project_name}-${var.environment_name}"
  container_definitions = data.template_file.wordpress_container_template.rendered

}
