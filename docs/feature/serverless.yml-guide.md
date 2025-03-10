# リポジトリ内で使用している serverless.yml ファイルについての説明

このガイドでは、リポジトリ内で使用している gitlab-ci.yml ファイルの説明を行います。

## YAML ファイルとは？

下記資料を参照(YAML とは、書き方等記載)

- <https://www.wakuwakubank.com/posts/488-it-yaml/#index_id0>

## YAML と JSON の互換性について

YAML ファイルと JSON ファイルには互換性があり、YAML→JSON、JSON→YAML への書き換えが可能である。  
ただし、YAML ファイルの方が人間にとって読みやすくなっている。

## 説明するファイル

| ファイル名     | 概要                                                           |
| -------------- | -------------------------------------------------------------- |
| serverless.yml | Severless FlameWork を用いてデプロイされるサービスの定義を行う |

### serverless.yml

Serverless Framework を用いてアプリケーション開発者が頻繁に触る、アプリケーションと密結合な部分の定義を行っている。  
`serverless deploy` を実行することで、定義を反映させることができる

- ファイル内で定義されているもの

  - Lambda 関数の環境変数等
  - API Gateway(パスやドメインについて)
  - DynamoDB の定義

- 参考資料
  - ドキュメント
    - <https://www.serverless.com/framework/docs/providers/aws/guide/serverless.yml/>
  - ソースコード
    - <https://github.com/serverless/examples/tree/v3/aws-node-http-api-typescript>
