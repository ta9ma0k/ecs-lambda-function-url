# suimon beta

## initalize app

### railsアプリケーションを構築する

#### Gemfileを作成する

```sh
rbenv local 3.3.0
bundle init
```

Gemfileを編集する。(./Gemfileを参照)

#### rails new

```sh
bundle
bundle exec rails new api --skip-bundle --skip-test --skip-active-record
cd api
rm -rf .git
```

### ローカル環境を構築する

#### dockerに関するファイルを作成する

- compose.yml
- docker/local/Dockerfile

#### Gemfile.lockを作成する

初回構築時はこれがないとNotFoundになってビルドに失敗する。

```sh
touch api/Gemfile.lock
```

#### build

```sh
docker compose build
docker compose run api bundle
```

## docker

- api
    - apiサーバ用コンテナ

### setup

```
docker compose build
docker compose up
```

### ECS

```
copilot --version
export APP_NAME=ecs-lambda-sample
export SVC_NAME=api
export ENV_NAME=test

export AWS_PROFILE=takuma
copilot app init $APP_NAME
copilot svc init --name $SVC_NAME --app $APP_NAME -d ./docker/copilot/Dockerfile -t "Load Balanced Web Service"
copilot env init --name $ENV_NAME --app $APP_NAME --profile takuma --default-config
copilot env deploy --name $ENV_NAME
copilot secret init --app $APP_NAME --cli-input-yaml copilot-env-input.yml
copilot svc deploy --name $SVC_NAME --env $ENV_NAME
```

### GithubActions

#### IAMロールを作成

```
terraform apply
```

#### デプロイ情報の登録

##### ECSクラスター名の取得

```shell
aws ecs list-clusters --output text \
  --query "clusterArns[?contains(@, '${APP_NAME}-${ENV_NAME}')]" \
  | cut -d/ -f2
```

##### ECSサービス名の取得

`--cluster`フラグの値は、手前で取得したECSクラスター名に差し替えてください。

```shell
aws ecs list-services --cluster "<ECSクラスター名>" --output text \
  --query "serviceArns[?contains(@, '${APP_NAME}-${ENV_NAME}')]" \
  | cut -d/ -f3
```

##### タスク定義名の取得

```shell
aws ecs list-task-definitions --status ACTIVE --sort DESC --output text \
  --query "taskDefinitionArns[?contains(@, '${APP_NAME}-${ENV_NAME}')]" \
  | cut -d/ -f2 | cut -d: -f1
```

##### ECRリポジトリURIの取得

```shell
aws ecr describe-repositories --output text \
  --query "repositories[?contains(repositoryUri, '$APP_NAME')].repositoryUri"
```

##### コンテナ名の取得

```shell
echo $SVC_NAME
```

ココから先はローカル環境での作業です。

```shell
gh variable set ECS_CLUSTER_NAME --body "<ECSクラスター名>"
gh variable set ECS_SERVICE_NAME --body "<ECSサービス名>"
gh variable set TASK_DEFINITION_NAME --body "<タスク定義名>"
gh variable set ECR_REPOSITORY_URI --body "<ECRリポジトリURI>"
gh variable set CONTAINER_NAME --body "<コンテナ名>"
```
