data "aws_lambda_function" "function" {
  function_name = var.function_name
}

resource "aws_iam_policy" "deploy_policy" {
  name   = "deploy-${var.function_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "lambda:UpdateFunctionCode"
      ],
      "Resource": "${data.aws_lambda_function.function.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = var.iam_role
  policy_arn = aws_iam_policy.deploy_policy.arn
}
