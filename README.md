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
bundle exec rails new api --skip-bundle --skip-test
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
