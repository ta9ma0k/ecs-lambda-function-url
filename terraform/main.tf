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

module "lambda_function" {
  source = "./modules/lambda_function" 

  function_name = "http-test-function"
  runtime = "python3.12"
  handler = "handler.main"
  zip_path = "../functions/lambda.zip"
}

module "iam_policy_lambda_deploy_attachment" {
  source = "./modules/iam_policy_lambda_deploy_attachment" 

  function_name = "http-test-function"
  iam_role = module.iam_role_api_deploy_github_oidc.name
}

output "role_name" {
  value = module.iam_role_api_deploy_github_oidc.name 
}
