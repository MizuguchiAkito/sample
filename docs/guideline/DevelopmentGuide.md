# 開発する上で気をつけたいこと

- [開発する上で気をつけたいこと](#開発する上で気をつけたいこと)
  - [このガイドはなんのためにあるのか](#このガイドはなんのためにあるのか)
  - [Practices](#practices)
    - [MUST](#must)
      - [あらゆる命名規則はあらかじめ決めておかなければならない](#あらゆる命名規則はあらかじめ決めておかなければならない)
      - [基本的には型を定義しなければならない](#基本的には型を定義しなければならない)
      - [API や イベントの Input/Output は型を定義しておかなければならない](#api-や-イベントの-inputoutput-は型を定義しておかなければならない)
      - [外部 API やサービスとの連携部分では直接依存ライブラリを呼び出してはならない](#外部-api-やサービスとの連携部分では直接依存ライブラリを呼び出してはならない)
    - [Recommend](#recommend)
      - [API の型は OpenAPI に書き起こし、そこから自動生成する](#api-の型は-openapi-に書き起こしそこから自動生成する)
      - [極力 any を使ってはならない](#極力-any-を使ってはならない)
      - [極力 utils に実装してはならない](#極力-utils-に実装してはならない)
      - [極力関数内で変数を直接変更してはならない](#極力関数内で変数を直接変更してはならない)
      - [ドキュメントは自動生成するか書き起こす](#ドキュメントは自動生成するか書き起こす)

## このガイドはなんのためにあるのか

このガイドはこのリポジトリで開発する上で考慮しなければならないプラクティスについてまとめてあります。  
必ずしもこれに従う必要は無いですが、その場合は代替して規約を定めるべきです。
以下の区分にしたがって分類されています。

- MUST
  - 必ず守らなければならないと言っていいレベルで準拠したいプラクティス
  - 守らない場合保守性が低下したり、可読性が著しく低下します
  - 自動テストがしにくくなることがあります
- Recommend
  - 多くの場合準拠した方が良いプラクティス
  - 守らない場合は設計の変更が必要になる場合があります
  - このアプリケーションの思想・コンセプトから外れる物も含みます
- optional
  - 必須では無いものの準拠した方が良いプラクティス
  - 使用しない場合でもこれに順ずる設計思想を定めておくと良いでしょう

## Practices

### MUST

#### あらゆる命名規則はあらかじめ決めておかなければならない

- 例
  - 変数名/関数名
    - グローバル変数
      - 極力使わないように...
    - 定数
    - mutable な変数
      - 決めない場合も多い
  - 型名/クラス名
  - フォルダ構造/ファイル名
  - API 名
  - エンドポイント名
  - サービス名
- 守られない場合
  - 大体もめるか無法地帯になるため
    - 可読性が大きく低下し、保守性が下がります
- 補足
  - ESlint で変数名のルールを整備出来ます
    - <https://typescript-eslint.io/rules/naming-convention/>

#### 基本的には型を定義しなければならない

- 例
  - Objectの型
  - 共通で使う型のalias
  - 配列の長さが決まっているならtupleを使う
- 守られない場合
  - 型情報が処理の途中で失われると処理が追いづらくなったり、隠れたバグの原因になります
- 補足
  - 型関連のルールは[@tsconfig/bases](https://github.com/tsconfig/bases)のstrictestで最大限厳しいものにしてあります。

#### API や イベントの Input/Output は型を定義しておかなければならない

- 守られない場合
  - 外部からのデータのため、不定なデータ型の場合は扱いづらくなります
- 補足
  - [API の型は OpenAPI に書き起こし、そこから自動生成する](#api-の型は-openapi-に書き起こしそこから自動生成する)

#### 外部 API やサービスとの連携部分では直接依存ライブラリを呼び出してはならない

- 守られない場合
  - 外部の仕様変更に対して大幅に弱くなります
  - 外部APIのバージョン毎に対して実装を切り替えるのがむずかしくなります
  - テストが困難になる可能性が高いです
- 補足
  - [API の型は OpenAPI に書き起こし、そこから自動生成する](#api-の型は-openapi-に書き起こしそこから自動生成する)

### Recommend

#### API の型は OpenAPI に書き起こし、そこから自動生成する

- 守られない場合
  - API情報のフロントエンド側や外部への共有がむずかしくなります
  - 型を二重メンテする可能性が出てきてしまいます
- 補足
  - このリポジトリでは、OpenAPIの情報を読み取ってルーティングの生成を行っています。
    - 現在未実装ですが、今後はOpenAPIの型情報を元に事前にバリデーションする機能を導入し、外部から来たデータであってもTypeScriptの型を完全に信頼できるものになる予定です

#### 極力 any を使ってはならない

- 守られない場合
  - 型情報が処理の途中で失われると処理が追いづらくなったり、隠れたバグの原因になります
- 補足
  - `never`や`unknown`、Genericsを使ってanyを極力減らしましょう

#### 極力 utils に実装してはならない

- 実装していいものの例
  - バリデーション関数
  - Logger
  - debug用の関数
  - 統一的/普遍的な処理をする関数
    - 型の変換を行うGenerics
    - 利用しているデータの変換を行う関数
      - 参考: [極力関数内で変数を直接変更してはならない](#極力関数内で変数を直接変更してはならない)
- 守られない場合
  - なんでもutilsに入れると全部utilsに入れるようになり収集がつかなくなる場合が多いです
  - 関数をどのファイルに入れるか迷ってしまうケースもあります
- 補足
  - 外部APIなどを参照する場合は、featureディレクトリを使って、1つのserviceとして実装しましょう

#### 極力関数内で変数を直接変更してはならない

- どのようなことか
  - 再利用性を高めるために[副作用](https://ja.wikipedia.org/wiki/%E5%89%AF%E4%BD%9C%E7%94%A8_(%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%A0))がないクリーンな状態にすることが望ましい
  - 引数にreadonlyを付けるかの判断はお任せしますが、現状はサポートが十分ではないため、付けなくても良いと思います
    - <https://zenn.dev/snamiki1212/scraps/9006206a583a70>
- [サンプルコード](https://www.typescriptlang.org/play?#code/PTAEnslQdeUCldBkGQhBkNEMho+QFAlAKm5gcgcR03TAEYA6UQVH1AHU0CSGQSE1AXs0HUGQMwZARBkVVQEsA7AC4BTAE4AzAIYBjYaADKkgLYAHADbCA3qlCgAFgHsA5sIBcofgFclAIzE79lo5PNXb9gL49pB-gGdBUD9ldWECUABeUG1dQxNzACYAGgc9JxdQAGYUr1Qff0DxS35pUgIAfWk9SX4TAAljOSiACgMbACtzRVUNJItrV2s7UQBKSIA+aIcMWkZWTkRAfQZAQIYoOCQHNvbyOKb+pVRcopKy-Erq2uEGk2bgnrD8PoBWEZ4MBMpANE1AFwVAOwYGejMdhcHgaQKScJRUjeXwBUDHaQJCqSdSWPwAQX4ABMADLGSKgZpuQbuUYTKa6DA-f6A+ZcFZrBDcXQQ-CgADUUTcDnyfgMGnIamMzVZryOxURyNRGOxeKMzUyrxIEBgdEAVgyAeQYWIs0BgiAB5ADSRGVFGotJYao4gHMGQDNDIAVhkAPwx0SCAYwY2IAV+MAmgzK5iwQDgkYBFtLVgBYNQAQKgAyQAwKoANBkA0eq-fUdYTSQSwRYawCqDIBkhkAX4psQCyDItAFEMXsQ4cA9gzSNSSPx+NWASwY6IB-eUAYgy-QBBDKRACYMv0A0kbWn18IRiKSyBQhDQxfSNEnDVLpOeeGEFeES0hG841eqNAmtDpdSfCPrE-bDEaH+7k6czGi-B3Ot1sUTCQSWUT8UDAparGCwK3TGAfjVGoQoAO6gD4KgAJ6ANYMFaABc2gDwhg4L5vh+0TkFhWx9LsJJeLkvKBHcoRGgS054aAyQLs45jZIcK5wiRGgAMIXCYWIEgiG6GlulzXMItxHkazxKu8Xx-ACcyANoMgBaDLBzCADH6vyACQKdDesqgC6DB22n+negBnioAYC4VoAYEqAEdp2qAJ2msCANGRgBYCSwsCAPZBNpDmCoCSGRUKMYUEoJJuKJqGie6nm457XoBoDUlJQILAyf4bLoaHvp+nmGhy+wMT5a4lP5vGSHKe5jBEkzTry-LCIKwppWKPCoGlXF+QF0oKq8CJ5eUBXCiMQA)
- 守られない場合
  - テストがむずかしくなることが多いです
  - 変数の動きが追いにくくなり、スパゲッティコードの原因になります
  - 共有して使っている変数がある場合、並行処理で値がおかしくなる場合があります
- 補足
  - 純粋関数にする必要性はありません(DBなどを触りに行く場合があるため)
    - フロントエンドの場合は、リアクティブ性の担保などのために同じObjectを触る場合があるため、過敏になる必要はないです

#### ドキュメントは自動生成するか書き起こす

- 開発向けのドキュメント置き場
  - README.md
  - コードコメント
    - JSDoc 等
      - <https://typedoc.org/>
  - Wiki
  - GitLab Pages
    - Markdownを利用して書き起こし、[MkDocs](https://www.mkdocs.org/)で生成する

- 外部向けのドキュメント置き場
  - S3 (+ CloudFront)
    - OpenAPI から自動生成
      - <https://swagger.io/tools/swagger-ui/>
      - <https://stoplight.io/open-source/elements>
    - DB スキーマから自動生成
      - SchemaSpy
