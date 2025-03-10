#!/bin/bash
OK="OK"
NG="NG"

set -eu

# git config コマンドを実行して結果を変数に格納
autocrlf=$(git config --get core.autocrlf)

if [ "$autocrlf" != "false" ]; then
    echo "${NG}: core.autocrlf の設定が 'false' ではありません。現在の設定: $autocrlf"
    exit 1
else
    echo -e "${OK}: git config --get core.autocrlf == false"
fi

# docker check
if ! docker run -it --rm mirror.gcr.io/hello-world > /dev/null; then
    # コマンドが失敗した場合
    echo -e "${NG}: docker run コマンドが失敗しました。\nDockerインストール後再起動を行っていない場合は、再起動を行ってください。\nまた、 docker info の出力も確認してください。"
    exit 1
else
    echo "${OK}: docker run は正常に実行されました"
fi


# VScode Check
## VSCodeのCLIを無効化している人もいるため
extension_id="ms-vscode-remote.remote-containers"
extension_label="拡張機能 Remote Containers (id: ${extension_id} )"
if ! which code > /dev/null; then
    echo -e "Visual Studio Codeがインストールされているか確認してください。\nまた、インストールされている場合、${extension_label}がインストールされているかも併せて確認して下さい。"
fi

if ! code --list-extensions | grep "${extension_id}" > /dev/null; then
    echo -e "${extension_label}がインストールされていません。\nインストールコマンド: code --install-extension ${extension_id}"
    exit 1
else
    echo "${OK}: Visual Studio Code & 拡張機能のインストール完了"
fi

echo -e "Complete!\n事前セットアップ確認スクリプトによる確認が完了しました！"
