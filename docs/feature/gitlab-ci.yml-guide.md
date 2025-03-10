# リポジトリ内で使用している gitlab-ci.yml ファイルについての説明

このガイドでは、リポジトリ内で使用している gitlab-ci.yml ファイルの説明を行います。

## YAML ファイルとは？

下記資料を参照(YAML とは、書き方等記載)

- <https://www.wakuwakubank.com/posts/488-it-yaml/#index_id0>

## YAML と JSON の互換性について

YAML ファイルと JSON ファイルには互換性があり、YAML→JSON、JSON→YAML への書き換えが可能である。  
ただし、YAML ファイルの方が人間にとって読みやすくなっている。

## 説明するファイル

| ファイル名    | 概要                                                                | 補足                                                    |
| ------------- | ------------------------------------------------------------------- | ------------------------------------------------------- |
| gitlab-ci.yml | GitLab の CI (GitLab Runner を使用し実行する処理)を記載したファイル | <https://www.redhat.com/ja/topics/devops/what-is-ci-cd> |

### gitlab-ci.yml

gitlab 上の CI ツール( gitlab Runner を使用した実装)の処理が記載されたファイルとなっている。

- ファイル内で記載されている内容

  - stage
    - ジョブのステージ
  - image
    - Docker イメージ
  - cache
    - キャッシュされるファイルのリスト
  - .use_dind
    - Docker in Docker に関する定義(specific runner の指定)
  - workflow
    - パイプラインが作成されるタイミング
  - lint
    - lint 実行時の処理
  - test
    - test 実行時の処理
  - build_and_deploy
    - build と deploy 実行時の処理

- 参考資料
  - ドキュメント
    - <https://gitlab-docs.creationline.com/ee/ci/yaml/README.html>
    - <https://docs.gitlab.com/ee/ci/yaml/index.html>
  - ソースコード
    - <https://gitlab.com/gitlab-org/gitlab/blob/master/.gitlab-ci.yml>
