module "immutable" {

  source                                = "../../infrastructure/immutable"

  #--------------------------------------------------------------
  # General
  #--------------------------------------------------------------
  aws_region                            = var.region
  build_number                          = var.build_number
  project_name                          = var.project_name
  environment_name                      = var.environment_name

}
