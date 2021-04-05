resource "aws_iam_role" "wordpress_eks_cluster" {

  name = "wordpress-eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "wordpress-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.wordpress_eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "wordpress-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.wordpress_eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "wordpress-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.wordpress_eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "wordpress-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.wordpress_eks_cluster.name
}

resource "aws_iam_instance_profile" "wordpress_eks_iam_instance_profile" {
  name = "wordpress-eks-cluster"
  role = aws_iam_role.wordpress_eks_cluster.name
}
