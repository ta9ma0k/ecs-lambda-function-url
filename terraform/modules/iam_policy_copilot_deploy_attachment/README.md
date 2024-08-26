# iam_policy_copilot_deploy_attachment

## 用途

copilot のデプロイに必要な権限を与える。

## サンプル

### IAM User に 権限を与える場合 
```
module "iam_policy_copilot_deploy_attachment" {
  source = "../../modules/iam_policy_copilot_deploy_attachment"

  iam_user = {
    name = "< IAM User name >"
  }
}
```

### IAM ロール に 権限を与える場合

```
module "iam_policy_copilot_deploy_attachment" {
  source = "../../modules/iam_policy_copilot_deploy_attachment"

  iam_role = {
    name = "< IAM Role Name >"
  }
}
```

