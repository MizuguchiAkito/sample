#!/usr/bin/env bash

set -eux

User=`whoami`

sudo chown -R $User node_modules
sudo chown -R $User dist

npm ci

# コンテナ内での準備状況確認スクリプト
sudo ln -s /workspace/tools/check_setup_progress.sh /usr/local/bin/check_setup_progress.sh
