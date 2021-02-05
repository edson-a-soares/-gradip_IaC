variable "project_name" {}
variable "build_number" {}
variable "environment_name" {}
variable "vpc_id" {}
variable "ec2_instance_type" {}
variable "ec2_image_id" {}
variable "docker_image" {}
variable "docker_image_version" {}
variable "container_cpu" {}
variable "container_memory" {}
variable "subnets" {
  type = list
}
variable "ecs_service_desired_capacity" {}
variable "ecs_autoscaling_max_instance_size" {}
variable "ecs_autoscaling_min_instance_size" {}
variable "ecs_service_health_check_grace_period" {}

variable "ec2_autoscaling_desired_capacity" {}
variable "ec2_autoscaling_max_instance_size" {}
variable "ec2_autoscaling_min_instance_size" {}
