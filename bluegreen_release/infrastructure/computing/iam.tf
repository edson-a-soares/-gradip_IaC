data "aws_iam_role" "ecsAutoscaleRole" {
  name = "ecsAutoscaleRole"
}

data "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole"
}

resource "aws_iam_role" "ecsServiceRole" {
  name = "ecsServiceRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_policy.json
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_policy_attachment" {
  role       = aws_iam_role.ecsServiceRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
