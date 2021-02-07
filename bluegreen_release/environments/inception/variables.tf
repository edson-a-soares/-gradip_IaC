variable "project_name" {
  default = "bluegreen"
}

variable "environment_name" {
  description = "The environment infrastructure for the operation."
  default = "inception"
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "build_number" {
  description = "Current build number."
  default = 0
}
