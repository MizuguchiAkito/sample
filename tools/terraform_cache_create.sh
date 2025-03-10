#!/bin/bash

set -eux

# 環境変数の確認
if [ -z "$TF_PLUGIN_CACHE_DIR" ]; then
  echo "Error: The TF_PLUGIN_CACHE_DIR environment variable is not set."
  exit 1
fi

# 念のため(初回はディレクトリがないと怒られたりする)
mkdir -p $TF_PLUGIN_CACHE_DIR

# Terraformの初期化
echo "Initializing Terraform..."

SCRIPT_DIR=$(cd $(dirname $0);pwd)

DIRECTORIES=(
  "$SCRIPT_DIR/../terraform/gitlab-runner"
  "$SCRIPT_DIR/../terraform/service"
)

for DIR in "${DIRECTORIES[@]}"; do
  # ディレクトリの存在チェック
  if [ ! -d "$DIR" ]; then
    echo "Error: Directory does not exist: $DIR"
    continue
  fi

  # ディレクトリに移動
  cd "$DIR" || { echo "Failed to enter directory: $DIR"; exit 1; }

  # Terraformの初期化
  echo "Initializing Terraform in $DIR..."
  terraform init
  cd - > /dev/null || exit
  sleep 3
done

# プラグインキャッシュのチェック
if [ ! -d "$TF_PLUGIN_CACHE_DIR" ]; then
  echo "Error: TF_PLUGIN_CACHE_DIR does not exist."
  exit 1
fi

# キャッシュを圧縮するファイル名を指定
CACHE_ARCHIVE="/tmp/tf_plugin_$(date '+%s')Z.tar.gz"

# 圧縮実行
echo "Compressing the plugin cache..."
tar -C "$TF_PLUGIN_CACHE_DIR" -czvf "$CACHE_ARCHIVE" .

if [ $? -eq 0 ]; then
  echo "Plugin cache compressed successfully: $CACHE_ARCHIVE"
else
  echo "Error: Failed to compress the plugin cache."
  exit 1
fi

mv $CACHE_ARCHIVE "$SCRIPT_DIR/../.caches/"
