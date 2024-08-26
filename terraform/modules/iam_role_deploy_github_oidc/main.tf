resource "random_string" "hash" {
  length  = 8
  special = false
}

locals {
  role_name = "oidc-github-${random_string.hash.result}"
}

data "aws_iam_policy_document" "github_actions_oidc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_proviter_arn]
    }
    condition {
      test     = "ForAnyValue:StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repo in var.github_repos : "repo:${repo}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_oidc" {
  name               = local.role_name
  assume_role_policy = data.aws_iam_policy_document.github_actions_oidc.json

  lifecycle {
    prevent_destroy = true
  }
}
