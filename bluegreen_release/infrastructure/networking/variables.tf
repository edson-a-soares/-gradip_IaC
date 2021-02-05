variable "project_name" {}

variable "build_number" {}

variable "environment_name" {}

variable "vpc_cidr" {}

variable "public_subnets_cidr" {
  type = list
}

variable "private_subnets_cidr" {
  type = list
}

variable "availability_zones" {
  type = list
}
