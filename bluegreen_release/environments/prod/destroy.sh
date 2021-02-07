#!/bin/bash

build_number=$1

terraform workspace select $build_number
terraform destroy -var build_number=$build_number -auto-approve

terraform workspace select default
terraform workspace destroy $build_number
