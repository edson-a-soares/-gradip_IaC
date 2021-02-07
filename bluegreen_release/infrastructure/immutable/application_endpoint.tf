resource "aws_globalaccelerator_accelerator" "application_endpoint" {
  name            = "${var.project_name}-${var.environment_name}-${var.build_number}"
  ip_address_type = "IPV4"
  enabled         = true
}
