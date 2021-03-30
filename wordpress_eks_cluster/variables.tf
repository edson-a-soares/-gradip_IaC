#----------------------------------------------------------------
# General settings.
#----------------------------------------------------------------
variable "terraform_profile" {
  default = "secondary"
}

variable "project_name" {
  default = "wordpress"
}

variable "environment_name" {
  description = "The environment infrastructure for the operation."
  default = "dev"
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "build_number" {
  description = "Current build number."
  default = "0"
}

#----------------------------------------------------------------
# Container settings.
#----------------------------------------------------------------
variable "docker_image" {
  description = "Image of the dockerized application."
  default = "wordpress"
}

variable "docker_image_version" {
  default = "5.6.0-apache"
}

variable "container_cpu" {
  default = "1"
}

variable "container_memory" {
  default = "256"
}

#----------------------------------------------------------------
# EC2 resources.
#----------------------------------------------------------------
variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_image_id" {
  default = "ami-0e5b37ba2c8e7cc82"
}

variable "ec2_autoscaling_max_instance_size" {
  default = 2
  description = "The maximum size of the Auto Scaling Group."
}

variable "ec2_autoscaling_desired_capacity" {
  default = 2
  description = "The number of Amazon EC2 instances that should be running in the group."
}

variable "ec2_autoscaling_min_instance_size" {
  default = 1
  description = "The minimum size of the Auto Scaling Group."
}


#----------------------------------------------------------------
# VPC resources.
#----------------------------------------------------------------
variable "subnets" {
  default = [ "subnet-6358dd05", "subnet-2ddb580c" ]
}

#----------------------------------------------------------------
# Database resources.
#----------------------------------------------------------------
variable "database_name" {
  default = "wordpress"
}

variable "rds_instance_type" {
  default = "db.t2.micro"
}

variable "database_username" {
  default = "wordpress"
}

variable "database_password" {
  default = "abc123456"
}

#----------------------------------------------------------------
# Wordpress data.
#----------------------------------------------------------------
variable "wordpress_table_prefix" {
  default = "wordpress_"
}

#----------------------------------------------------------------
# ECS settings.
#----------------------------------------------------------------
variable "ecs_service_desired_capacity" {
  description = "Number of instantiations of the specified task definition to place and keep running on your cluster."
  default = 4
}

variable "ecs_service_health_check_grace_period" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown."
  default = 30
}

variable "ecs_autoscale_max_instance_size" {
  default = 4
}

variable "ecs_autoscale_min_instance_size" {
  default = 1
}
