resource "aws_iam_role" "eksClusterRole" {
  name = "eksClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_service_policy.json
}

data "aws_iam_policy_document" "eks_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_service_role_policy_attachment" {
  role       = aws_iam_role.eksClusterRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
