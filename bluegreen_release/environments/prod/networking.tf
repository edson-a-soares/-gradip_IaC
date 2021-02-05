module "networking" {

  source                                = "../../infrastructure/networking"

  #--------------------------------------------------------------
  # General
  #--------------------------------------------------------------
  build_number                          = var.build_number
  project_name                          = var.project_name
  environment_name                      = var.environment_name

  #--------------------------------------------------------------
  # VPC
  #--------------------------------------------------------------
  vpc_cidr                              = "10.0.0.0/16"
  public_subnets_cidr                   = [ "10.0.0.0/18", "10.0.64.0/18" ]
  private_subnets_cidr                  = [ "10.0.128.0/18", "10.0.192.0/18" ]
  availability_zones                    = [ "us-east-1a", "us-east-1b" ]

}
