#!/bin/bash

build_number=$1

terraform workspace select $build_number
terraform plan -var build_number=$build_number -var release_new_environment=1
terraform apply -var build_number=$build_number -var release_new_environment=1 -auto-approve
