# リポジトリ内で使用している openapi.json ファイルについての説明

このガイドでは、リポジトリ内で使用している openapi.json ファイルの説明を行います。

## YAML と JSON の互換性について

YAML ファイルと JSON ファイルには互換性があり、YAML→JSON、JSON→YAML への書き換えが可能である。  
ただし、YAML ファイルの方が人間にとって読みやすくなっている。

## 説明するファイル

| ファイル名   | 概要                           |
| ------------ | ------------------------------ |
| openapi.json | OpenAPI を定義しているファイル |

### openapi.json

OpenAPI の定義を JSON ファイルにて行っている。

- 記述事項

  - openapi
    - OpenAPI のバージョン
  - info
    - API のメタデータを定義
      - title(API のタイトル)
      - version(ドキュメントのバージョン)
  - servers
    - API を提供するサーバーを記述
      - url(API を提供しているサーバーの URL)
  - paths
    - API として利用可能なパス及び操作を定義
      - HTTP メソッドを記載
  - components
    - ドキュメントのさまざまなスキーマを保持する要素
      - schemas(コンポーネントの定義)

### ファイルを書き換える場合

<!-- json ファイルを書き換えるならどうやるかを記載する -->

### 参考資料

- <https://spec.openapis.org/oas/latest.html#openapi-object>
