resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.project_name}-${var.environment_name}"

  role_arn = aws_iam_role.eksClusterRole.arn

  vpc_config {
    subnet_ids = var.subnets
  }

  timeouts {
    delete    = "30m"
  }

}
