# トレーニング用ファイルの目次

このドキュメントでは、トレーニングをスムーズに行うために、training フォルダ以下の階層のディレクトリ構造の説明を行います。

## ディレクトリ構造

training フォルダ以下のディレクトリ構造を以下に記載します。

```txt
.
docs/training
├── 1.coding # コーディングについての解説を行うフォルダ
|   ├── 1.dev-environment.md # 開発環境について
|   ├── 2.app-implement.md # アプリの実装
|   ├── 3.app-execution.md # アプリの実行
|   └── 4.database.md # データベース
├── 2.application # アプリ自体の解説を行うフォルダ
|   ├── 1.architecture.md # アーキテクチャ
|   ├── 2.flamework.md # 使用フレームワーク
|   ├── 3.processing-flow.md # 処理の流れ
|   └── 4.deploy.md # デプロイ方法
├── 3.infrastructure # インフラについての解説を行うフォルダ
|   ├── 1.dockerfile.md # Dockerfileについて
|   ├── 2.serverless.yml.md # serverless.ymlについて
|   ├── 3.terraform.md # terraformについて
├── basic # ハンズオン（基礎編）についての解説を行うフォルダ
|   ├── README.md # ハンズオンで実施する手順について
|   ├── setup.md # ハンズオン実施前に行うセットアップについて
|   ├── Troubleshooting.md # ハンズオンに想定されるトラブルについて
├── .gitkeep
├── guide-agenda.md # このファイル
└── how-to-contribute.md # このリポジトリへのContribute方法について
```

## 各フォルダの簡単な説明

### coding フォルダ

`coding`フォルダでは、コーディングについての解説を行っている。  
解説項目としては以下が挙げられる。

- [開発環境について](/docs/training/1.coding/1.dev-environment.md)
  - devcontainer について
  - 起動方法
  - トラブルシューティング
- [アプリの実装](/docs/training/1.coding/2.app-implement.md)

  - API における HTTP メソッド実装手順
    - OpenAPI.json の簡単な実装例
    - コードについて
  - Lambda 関数実装手順
    - serverless.yml について
    - コードについて
  - feature(Service)や Util について
    - 書き方
      - 分け方
    - 単体テスト
    - DI(Dependency Injection)について
      - どこで DI しているのか
      - どんな恩恵があるのか

- [アプリの実行](/docs/training/1.coding/3.app-execution.md)
  - npm scriptsについて
    - 既存の npm scripts 概説
      - テスト及び lint の実行方法
    - 実装方法
  - ローカルでの実行
    - tools ディレクトリについて
    - API サーバー(npm scripts)
    - Lambda 関数
  - AWS 上での実行

- [データベースについて](/docs/training/1.coding/4.database.md)
  - 使用ツールの概説
    - DynamoDB の書き方(serverless.yml)
    - PostgreSQL の書き方

### application フォルダ

`application`フォルダでは、実装するアプリ自体の解説を行っている。  
解説項目としては以下が挙げられる。

- [アーキテクチャ](/docs/training/2.application/1.architecture.md)
- [使用フレームワーク](/docs/training/2.application/2.framework.md)
  - ライセンスについて
- [処理の流れ](/docs/training/2.application/3.processing-flow.md)
- [デプロイ方法](/docs/training/2.application/4.deploy.md)
  - 初回の場合
  - CI/CD について

### infrastructure フォルダ

`infrastructure`フォルダでは、インフラ項目についての解説を行っている。  
解説項目としては以下が挙げられる。

- [Dockerfile](/docs/training/3.Infrastructure/1.dockerfile.md)
  - 既存のコードの解説
  - serverless.yml での entrypoint の変更方法、仕組み
  - Dockerfile の書き方
- [serverless.yml](/docs/training/3.Infrastructure/2.serverless.yml.md)
  - Lambda 関数の定義方法
    - 代表的な`events`について
  - Lambda 関数の Secret の設定方法
  - serverless.yml の書き方
- [terraform](/docs/training/3.Infrastructure/3.terraform.md)
  - AWS へのデプロイ方法
  - terraform の書き方

### basic フォルダ
`basic`フォルダでは、ハンズオン（基礎編）にて実施する内容についての解説を行っている。
解説項目としては以下が挙げられる。
- [README](/docs/training/basic/README.md)
  - ハンズオンの内容で実践するコマンドなどといった手順について記載している。
- [setup](/docs/training/basic/setup.md)
  - ハンズオンを受講する以前に行う事前準備について記載している。
    

## トレーニングを実施するにあたってのお願い

本リポジトリにてトレーニングを実施する際ですが、トレーニングを行う順序として、

- `coding`フォルダ →`application`フォルダ →`infrastructure`フォルダ

上記の順序でトレーニングしていただくことをお勧めします。  
また、各フォルダ内のファイルについて、ファイル名の先頭に数字が振られておりますので、数字の昇順に確認していただけるとよりスムーズにトレーニングが実施できます。
