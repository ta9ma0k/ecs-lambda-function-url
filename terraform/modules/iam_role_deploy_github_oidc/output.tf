output "arn" {
  value = aws_iam_role.github_actions_oidc.arn
}

output "name" {
  value = local.role_name
}
