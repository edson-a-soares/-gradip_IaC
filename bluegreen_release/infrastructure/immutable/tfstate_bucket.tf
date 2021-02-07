resource "aws_s3_bucket" "terraform_remote_state" {
  acl    = "private"
  bucket = "${var.project_name}.terraform"
  tags = {
    Name = "${var.project_name}-${var.environment_name}-${var.build_number}"
  }
}
