data "aws_iam_role" "ecsAutoscaleRole" {
  name = "ecsAutoscaleRole"
}

data "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole"
}

data "aws_iam_role" "ecsServiceRole" {
  name = "ecsServiceRole"
}
