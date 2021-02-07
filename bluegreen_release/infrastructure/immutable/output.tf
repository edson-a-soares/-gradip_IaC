output "tfstate_bucket_unique_name" {
  value = aws_s3_bucket.terraform_remote_state.id
  depends_on = [aws_s3_bucket.terraform_remote_state]
}

output "application_endpoint_id" {
  value = aws_globalaccelerator_accelerator.application_endpoint.id
}
