#!/bin/bash

build_number=$1

terraform init
terraform workspace new $build_number
terraform plan -var build_number=$build_number
terraform apply -var build_number=$build_number -auto-approve
