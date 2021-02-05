resource "random_string" "lc_suffix" {

  length  = 15
  special = false
  upper   = true
  number  = true

}

resource "aws_launch_configuration" "cluster-launch-configuration" {

  name                        = "${var.project_name}-${var.environment_name}-v${var.build_number}-${random_string.lc_suffix.result}"
  image_id                    = var.ec2_image_id
  instance_type               = var.ec2_instance_type
  iam_instance_profile        = data.aws_iam_role.ecsInstanceRole.name
  enable_monitoring           = true

  root_block_device {
    volume_type           = "standard"
    volume_size           = 30
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  associate_public_ip_address = true
  security_groups             = [ aws_security_group.http_security_group.id ]
  user_data                   = "#!/bin/bash \necho ECS_CLUSTER=${var.project_name}-${var.environment_name}-v${var.build_number} >> /etc/ecs/ecs.config"

}
