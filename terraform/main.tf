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

output "role_name" {
  value = module.iam_role_api_deploy_github_oidc.name 
}
