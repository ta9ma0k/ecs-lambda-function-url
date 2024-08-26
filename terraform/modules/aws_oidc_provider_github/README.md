# aws oidc provider github actions

## 用途

AWS 上に、 github actions の open id connect privider を作成する。<br>
provider は一つの AWS 上に 1 つまでしか作成できないので、切り分けた。<br>
<br>
こちらを元に、複数 role を作成することになる。

## サンプル

```
module "aws_oidc_provider_github" {
  source = "../../modules/aws_oidc_provider_github"
}

# リポジトリを指定し、ロールの作成
module "iam_role_deploy_github_oidc" {
  source = "../../modules/iam_role_deploy_github_oidc"

  oidc_proviter_arn = module.aws_oidc_provider_github.arn
  github_repos = [
    "kayac/op-hogehoge"
  ]
}

# ポリシーをアタッチする。この例では s3 へのアクセス権限
module "iam_policy_s3_deploy_attachment" {
  source = "../../modules/iam_policy_s3_deploy_attachment"

  iam_role = {
    name = module.iam_role_deploy_github_oidc.name
  }

  buckets = [
    "hogehoge-stg",
    "hogehoge-prod",
  ]
}
```
