resource "aws_eks_node_group" "wordpress_eks_cluster_worker_nodes" {

  subnet_ids      = var.subnets
  node_group_name = "wordpress_eks_cluster_worker_nodes"
  node_role_arn   = aws_iam_role.wordpress_eks_cluster.arn
  cluster_name    = aws_eks_cluster.wordpress_eks_cluster.name

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t2.micro"]

  tags = {
    Version = var.build_number
    Environment = var.environment_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.wordpress-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.wordpress-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.wordpress-AmazonEC2ContainerRegistryReadOnly,
  ]

}
