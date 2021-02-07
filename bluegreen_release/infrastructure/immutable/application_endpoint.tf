resource "aws_globalaccelerator_accelerator" "application_endpoint" {
  name            = "${var.project_name}-${var.environment_name}-${var.build_number}"
  ip_address_type = "IPV4"
  enabled         = true
}

resource "aws_globalaccelerator_listener" "endpoint_listener" {

  accelerator_arn = aws_globalaccelerator_accelerator.application_endpoint.id
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }

}
