provider "aws" {
  region = "ap-northeast-1"
}

module "oidc_provider_github_actions" {
  source = "./modules/aws_oidc_provider_github"
}

module "iam_role_api_deploy_github_oidc" {
  source = "./modules/iam_role_deploy_github_oidc"

  oidc_proviter_arn = module.oidc_provider_github_actions.arn
  github_repos = [
    "ta9ma0k/ecs-lambda-function-url"
  ]
}

module "iam_policy_copilot_deploy_attachment" {
  source = "./modules/iam_policy_copilot_deploy_attachment"

  iam_role = module.iam_role_api_deploy_github_oidc.name
  copilot_app_name = "ecs-lambda-sample"
  copilot_envs     = ["test"]
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_lambda_function" "my_lambda_function" {
  function_name = "http-test-function"
  handler       = "handler.main"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "../functions/lambda.zip"
}

resource "aws_lambda_function_url" "my_lambda_function_url" {
  function_name = aws_lambda_function.my_lambda_function.function_name
  authorization_type = "AWS_IAM"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.my_lambda_function.function_name}"
  retention_in_days = 7
}

output "function_url" {
  value = aws_lambda_function_url.my_lambda_function_url.function_url
}

output "role_name" {
  value = module.iam_role_api_deploy_github_oidc.name 
}
