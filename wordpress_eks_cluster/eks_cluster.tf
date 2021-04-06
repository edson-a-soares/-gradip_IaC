resource "aws_eks_cluster" "wordpress_eks_cluster" {

  role_arn = aws_iam_role.wordpress_eks_cluster.arn
  name     = "${var.project_name}-${var.environment_name}-${var.build_number}"

  vpc_config {
    subnet_ids = var.subnets
    security_group_ids = [ aws_security_group.wordpress_eks_cluster.id ]
  }

  timeouts {
    delete    = "30m"
  }

}
