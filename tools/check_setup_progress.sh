#!/bin/bash
#
# devcontainer内でのセットアップが完了しているか確認します。

####################################### Const values #######################################
CREDENTIALS="$HOME/.aws/credentials"
CONFIG="$HOME/.aws/config"
HANDSON_ACCOUNT_ID=394895440631
HANDSON_REGION=ap-northeast-1
WORK_DIR="/workspace"
SERVERLESS_YML="$WORK_DIR/serverless.yml"
SERVERLESS_VAR_DIR="$WORK_DIR/config"
GITLAB_CI_YML="$WORK_DIR/.gitlab-ci.yml"
GITHUB_ACIONS_CHECK_YML="$WORK_DIR/.github/workflows/check.yml"
GITHUB_ACIONS_DEV_DEPLOY_YML="$WORK_DIR/.github/workflows/dev_deploy.yml"
GITHUB_ACIONS_REV_DEPLOY_YML="$WORK_DIR/.github/workflows/review_deploy.yml"
GITHUB_ACIONS_REV_REMOVE_YML="$WORK_DIR/.github/workflows/review_remove.yml"
GITHUB_OIDC_ROLE_ARN_PATTERN="arn:aws:iam::$HANDSON_ACCOUNT_ID:role/faas-[a-z][0-9]+-github-oidc"
APPS_DOMAIN_PATTERN="^-api-[a-z][0-9]+\.faas-handson\.cnt-tdc\.com$"

####################################### Function definitions #######################################

#######################################
# 標準エラー出力にメッセージを出力します。
# Arguments:
#   出力するメッセージ
# Outputs:
#   標準エラー出力にメッセージを出力する
#######################################
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

#######################################
# awsの認証情報を確認します。
# Globals:
#   CREDENTIALS: aws認証情報ファイルパス
# Arguments:
#   確認するプロファイル名
# Returns:
#   確認失敗の場合エラーコード（1）
#######################################
function valid_a_credential () {
  if ! grep -q "^\[$1\]" $CREDENTIALS; then
    err "[$1]の認証情報が未設定です。"
    return 1
  fi

  cred_params=$(awk -vRS= "/\\[$1\\]/,/\\[/{print}" "$CREDENTIALS")

  if ! `echo $cred_params | grep -qE "aws_access_key_id\s*="`; then
    err "[$1]のaws_access_key_idが未設定です。"
    return 1
  fi

  if ! `echo $cred_params | grep -qE "aws_secret_access_key\s*="`; then
    err "[$1]のaws_secret_access_keyが未設定です。"
    return 1
  fi
}

#######################################
# awsプロファイルを確認します。
# Globals:
#   CONFIG: awsプロファイル設定ファイルパス
# Arguments:
#   確認するプロファイル名
# Returns:
#   確認失敗の場合エラーコード（1）
#######################################
function valid_a_profile () {
  section="profile $1"
  if ! grep -q "^\[$section\]" "$CONFIG"; then
    err "プロファイル[$1]が未設定です。"
    return 1
  fi

  conf_params=$(awk -vRS= "/\\[$section\\]/,/\\[/{print}" "$CONFIG")

  if ! `echo $conf_params | grep -qE "region\s*=\s*$HANDSON_REGION"`; then
    err "プロファイル[$1]のregionが未設定です。"
    return 1
  fi

  if ! `echo $conf_params | grep -qE "role_arn\s*=\s*arn:aws:iam::$HANDSON_ACCOUNT_ID:role/faas-seed-handson-[0-9]{8}"`; then
    err "プロファイル[$1]のrole_arnが未設定です。"
    return 1
  fi

  if ! `echo $conf_params | grep -qE "source_profile\s*=\s*default"`; then
    err "プロファイル[$1]のsource_profileが未設定です。"
    return 1
  fi

  if ! `echo $conf_params | grep -qE "cli_pager\s*=\s*"`; then
    err "プロファイル[$1]のcli_pagerが未設定です。"
    return 1
  fi

  # 環境変数チェック
  if [ -z "${AWS_PROFILE}" ]; then
    err "環境変数にAWS_PROFILEが設定されていません。"
    return 1
  fi

  # プロファイル名誤りチェック
  if [ "${AWS_PROFILE}" != "$1" ]; then
    err "環境変数AWS_PROFILEが「$1」に設定されていません。"
    return 1
  fi
}

#######################################
# yamlプロパティエラー時のメッセージを出力します。
# Arguments:
#   プロパティ名
# Outputs:
#   標準エラー出力へyamlプロパティエラーメッセージを出力する
#######################################
function yaml_prop_err() {
  err "プロパティ: 「$1」 が修正されていません"
}

#######################################
# Serverlessフレームワークの設定内容を確認します。
# Arguments:
#   設定ファイルパス
# Returns:
#   確認失敗の場合エラーコード（1）
#######################################
function valid_a_serverless_config() {
  # Target properties
  key_service="service"
  key_domain_name="custom.customDomain.domainName"
  key_crt_name="custom.customDomain.certificateName"

  service=`yq '.'$key_service $1`
  if ! [[ $service =~ ^faas-[a-z][0-9]+$ ]]; then
    yaml_prop_err $key_service
    return 1
  fi

  domain_name=`yq '.'$key_domain_name $1`
  if ! [[ $domain_name =~ \
    ^\$\{sls:stage\}-api-[a-z][0-9]+\.faas-handson\.cnt-tdc\.com$ ]]; then
      yaml_prop_err $key_domain_name
      return 1
  fi

  crt_name=`yq '.'$key_crt_name $1`
  if ! [[ $crt_name =~ ^\*\.faas-handson\.cnt-tdc\.com$ ]]; then
    yaml_prop_err $key_crt_name
    return 1
  fi
}

#######################################
# Serverlessフレームワークの変数の設定内容を確認します。
# Arguments:
#   変数設定ファイルパス
# Returns:
#   確認失敗の場合エラーコード（1）
#######################################
valid_serverless_variables() {
  # Target properties
  key_short_prefix="shortPrefix"

  short_prefix=`yq '.'$key_short_prefix $1`
  if ! [[ $short_prefix =~ ^faas-[a-z][0-9]+$ ]]; then
    yaml_prop_err $key_short_prefix
    return 1
  fi
}

#######################################
# GitLab CI設定ファイルの内容を確認します。
# Globals:
#   HANDSON_ACCOUNT_ID: デプロイ先のAWSアカウントID
# Arguments:
#   変数設定ファイルパス
# Returns:
#   確認失敗の場合エラーコード（1）
#######################################
valid_gitlab_ci_settings() {
  # Target properties
  key_apps_domain="variables.APPS_DOMAIN"
  key_aws_account="variables.AWS_ACCOUNT"
  key_img_path="variables.IMAGE_PATH"

  apps_domain=`yq '.'$key_apps_domain $1`
  if ! [[ $apps_domain =~ ^-api-[a-z][0-9]+\.faas-handson\.cnt-tdc\.com$ ]]; then
    yaml_prop_err $key_apps_domain
    return 1
  fi

  aws_account=`yq '.'$key_aws_account $1`
  if ! [[ $aws_account == $HANDSON_ACCOUNT_ID ]]; then
    yaml_prop_err $key_aws_account
    return 1
  fi

  img_path=`yq '.'$key_img_path $1`
  if ! [[ $img_path =~ ^faas-[a-z][0-9]+-lambda-repository-dev$ ]]; then
    yaml_prop_err $key_img_path
    return 1
  fi
}

#######################################
# GitHub Actions の `check` Workflowファイルの内容を確認します。
# Globals:
#   GITHUB_OIDC_ROLE_ARN_PATTERN: GitHub OIDC用IAMロールARNの正規表現パターン
#   HANDSON_REGION: ハンズオンで使用するAWSリージョン
# Arguments:
#   変数設定ファイルパス
# Returns:
#   確認失敗の場合エラーコード（1）
#######################################
valid_github_actions_check_workflow() {
  # Target properties
  key_repository="jobs.build.with.repository"
  key_assume_role="jobs.build.with.assume_role"
  key_aws_region="jobs.build.with.aws_region"

  repository=`yq '.'$key_repository $1`
  if ! [[ $repository =~ ^faas-[a-z][0-9]+-lambda-repository-dev$ ]]; then
    yaml_prop_err $key_repository
    return 1
  fi

  assume_role=`yq '.'$key_assume_role $1`
  if ! [[ $assume_role =~ $GITHUB_OIDC_ROLE_ARN_PATTERN ]]; then
    yaml_prop_err $key_assume_role
    return 1
  fi

  aws_region=`yq '.'$key_aws_region $1`
  if ! [[ $aws_region == $HANDSON_REGION ]]; then
    yaml_prop_err $key_aws_region
    return 1
  fi
}

#######################################
# GitHub Actions の `deploy` Workflowファイルの内容を確認します。
# Globals:
#   GITHUB_OIDC_ROLE_ARN_PATTERN: GitHub OIDC用IAMロールARNの正規表現パターン
#   HANDSON_REGION: ハンズオンで使用するAWSリージョン
#   APPS_DOMAIN_PATTERN: APPドメイン名の正規表現パターン
# Arguments:
#   変数設定ファイルパス
# Returns:
#   確認失敗の場合エラーコード（1）
#######################################
valid_github_actions_deploy_workflow() {
  # Target properties
  key_assume_role="jobs.serverless_deploy.with.assume_role"
  key_aws_region="jobs.serverless_deploy.with.aws_region"
  key_app_domain="jobs.serverless_deploy.with.app_domain"

  assume_role=`yq '.'$key_assume_role $1`
  if ! [[ $assume_role =~ $GITHUB_OIDC_ROLE_ARN_PATTERN ]]; then
    yaml_prop_err $key_assume_role
    return 1
  fi

  aws_region=`yq '.'$key_aws_region $1`
  if ! [[ $aws_region == $HANDSON_REGION ]]; then
    yaml_prop_err $key_aws_region
    return 1
  fi

  app_domain=`yq '.'$key_app_domain $1`
  if ! [[ $app_domain =~ $APPS_DOMAIN_PATTERN ]]; then
    yaml_prop_err $key_app_domain
    return 1
  fi
}

#######################################
# GitHub Actions の `remove` Workflowファイルの内容を確認します。
# Globals:
#   GITHUB_OIDC_ROLE_ARN_PATTERN: GitHub OIDC用IAMロールARNの正規表現パターン
#   HANDSON_REGION: ハンズオンで使用するAWSリージョン
#   APPS_DOMAIN_PATTERN: APPドメイン名の正規表現パターン
# Arguments:
#   変数設定ファイルパス
# Returns:
#   確認失敗の場合エラーコード（1）
#######################################
valid_github_actions_remove_workflow() {
  # Target properties
  key_assume_role="jobs.serverless_deploy.with.assume_role"
  key_aws_region="jobs.serverless_deploy.with.aws_region"
  key_app_domain="jobs.serverless_deploy.with.app_domain"

  assume_role=`yq '.'$key_assume_role $1`
  if ! [[ $assume_role =~ $GITHUB_OIDC_ROLE_ARN_PATTERN ]]; then
    yaml_prop_err $key_assume_role
    return 1
  fi

  aws_region=`yq '.'$key_aws_region $1`
  if ! [[ $aws_region == $HANDSON_REGION ]]; then
    yaml_prop_err $key_aws_region
    return 1
  fi

  app_domain=`yq '.'$key_app_domain $1`
  if ! [[ $app_domain =~ $APPS_DOMAIN_PATTERN ]]; then
    yaml_prop_err $key_app_domain
    return 1
  fi
}

####################################### main #######################################

# defaultプロファイルが設定されているか確認
if ! valid_a_credential default; then
  err "defaultプロファイルが設定されていません。"
  exit 1
fi

# ハンズオン用の認証情報が設定されているか確認
if ! valid_a_profile handson; then
  err "handsonプロファイルが設定されていません。"
  exit 1
fi

# 認証情報が正しいか確認
if ! aws sts get-caller-identity --region $HANDSON_REGION; then
  err "AWS認証情報に誤りがあります。"
  exit 1
fi

# ymlの修正が完了しているか確認
if ! valid_a_serverless_config $SERVERLESS_YML; then
  err "${SERVERLESS_YML}の修正が完了していません。"
  exit 1
fi

serverless_var_files=`find $SERVERLESS_VAR_DIR -type f`
for var_file in $serverless_var_files; do
  if ! valid_serverless_variables $var_file; then
    err "${var_file}の修正が完了していません。"
    exit 1
  fi
done

# BPでも研修に参加できるようにリポジトリサービスをGitLab -> GitHubに変更したため、確認項目を変更
# if ! valid_gitlab_ci_settings $GITLAB_CI_YML; then
#   err "${GITLAB_CI_YML}の修正が完了していません。"
#   exit 1
# fi

if ! valid_github_actions_check_workflow $GITHUB_ACIONS_CHECK_YML; then
  err "${GITHUB_ACIONS_CHECK_YML}の修正が完了していません。"
  exit 1
fi

if ! valid_github_actions_deploy_workflow $GITHUB_ACIONS_DEV_DEPLOY_YML; then
  err "${GITHUB_ACIONS_DEV_DEPLOY_YML}の修正が完了していません。"
  exit 1
fi

if ! valid_github_actions_deploy_workflow $GITHUB_ACIONS_REV_DEPLOY_YML; then
  err "${GITHUB_ACIONS_REV_DEPLOY_YML}の修正が完了していません。"
  exit 1
fi

if ! valid_github_actions_remove_workflow $GITHUB_ACIONS_REV_REMOVE_YML; then
  err "${GITHUB_ACIONS_REV_REMOVE_YML}の修正が完了していません。"
  exit 1
fi

# カレントディレクトリがterraformの実行ディレクトリか確認
if [ `pwd` != "$WORK_DIR/terraform/service" ]; then
  err "Terraformが実行可能なディレクトリにいません。"
  exit 1
fi

echo '"AWS CLIの設定" 及び "サービス名の設定"が完了しています！'
