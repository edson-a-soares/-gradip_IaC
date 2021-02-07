module "computing" {

  source                                  = "../../infrastructure/computing"

  #--------------------------------------------------------------
  # General
  #--------------------------------------------------------------
  region                                  = var.region
  build_number                            = var.build_number
  project_name                            = var.project_name
  environment_name                        = var.environment_name

  #--------------------------------------------------------------
  # Computing
  #--------------------------------------------------------------
  ec2_instance_type                       = "t2.micro"
  ec2_image_id                            = "ami-0e5b37ba2c8e7cc82"
  vpc_id                                  = module.networking.vpc_id

  #--------------------------------------------------------------
  # If true, it deploys the new environment as production.
  #--------------------------------------------------------------
  release_environment                     = var.release_new_environment

  #--------------------------------------------------------------
  # Cluster
  #--------------------------------------------------------------
  docker_image                            = "httpd"
  docker_image_version                    = "latest"
  container_cpu                           = "1"
  container_memory                        = "256"
  ecs_service_desired_capacity            = 1
  ecs_autoscaling_max_instance_size       = 2
  ecs_autoscaling_min_instance_size       = 1
  ecs_service_health_check_grace_period   = 30
  subnets                                 = module.networking.public_subnets

  #--------------------------------------------------------------
  # Autoscaling
  #--------------------------------------------------------------
  ec2_autoscaling_desired_capacity        = 1
  ec2_autoscaling_max_instance_size       = 1
  ec2_autoscaling_min_instance_size       = 1

  #--------------------------------------------------------------
  # Autoscaling
  #--------------------------------------------------------------
  global_endpoint_weight                  = var.endpoint_weight
  global_endpoint_listener_arn            = "arn:aws:globalaccelerator::155490492186:accelerator/05f61aae-e424-4380-af7c-7fabd52e6c24/listener/5f72be81"
}
