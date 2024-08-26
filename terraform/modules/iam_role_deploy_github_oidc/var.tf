variable "github_repos" {
  type        = set(string)
  description = "owner/repository 形式の配列を指定してください。"
}

variable "oidc_proviter_arn" {
  type        = string
  description = "OIDCプロバイダのARNを指定してください。"
}
