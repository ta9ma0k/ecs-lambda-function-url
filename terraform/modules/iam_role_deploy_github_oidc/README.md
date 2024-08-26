# iam_role_deploy_github_oidc

## 用途

なんの権限も与えていない、iam role を作成します。<br>
この module 自体は、何も操作権限は付与しないため、追加で policy をアタッチする必要があります。<br>
<br>
github actions で 処理をするときに oidc で認証して、aws 上のリソースの取り扱いを行うことができる。<br>
<br>
thumbprint が自動で更新されないので、github の証明書が更新されたときは、`terraform apply`をし直す必要がある。

## Usage

```terraform
provider "aws" {
  region = "ap-northeast-1"
}

module "aws_oidc_provider_github" {
  source = "../../modules/aws_oidc_provider_github"
}

module "iam_role_s3_deploy_github_oidc" {
  source = "../../modules/iam_role_s3_deploy_github_oidc"

  oidc_proviter_arn = module.aws_oidc_provider_github.arn
  github_repos = [
    "<owner/リポジトリ 形式で指定。（複数記載可）>"
  ]
}

# 追加で、Roleへ必要なポリシーをアタッチする
```

### github actions

```yml
permissions:
  id-token: write
  contents: read

jobs:
  job_name:
    runs-on: ubuntu-latest
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: <terraform output で確認したarnを記入. (例)arn:aws:iam::xxx:role/oidc-github-xxxxxxxx>
          aws-region: ap-northeast-1
```

### 命名について補足

`https://github.com/kayac/cl-infrastructure` について設定をする場合、以下のようになります。

```terraform
github_repos = [
  "kayac/cl-infrastructure"
]
```
