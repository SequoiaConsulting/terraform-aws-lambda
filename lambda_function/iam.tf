resource "aws_iam_role" "lambda" {
  name = "${var.function_name}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  #count = length(var.policies) == 0 ? 0 : 1
  name  = "${var.function_name}-lambda-policy"
  role  = aws_iam_role.lambda.id
  policy = var.policies
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  for_each = var.managed_policies
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}
