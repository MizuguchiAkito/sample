@echo off
rem cmdの文字コードをUTF-8に変更
chcp 65001 > nul
setlocal enabledelayedexpansion

set "OK=OK"
set "NG=NG"

rem git config コマンドを実行して結果を変数に格納
for /f "delims=" %%i in ('git config --get core.autocrlf') do set "autocrlf=%%i"

if "!autocrlf!" neq "false" (
    echo "%NG%: core.autocrlf の設定が 'false' ではありません。現在の設定: !autocrlf!"
    exit /b 1
) else (
    echo "%OK%: git config --get core.autocrlf == false"
)

rem docker check
docker run -it --rm mirror.gcr.io/hello-world >nul 2>&1
if errorlevel 1 (
    echo "%NG%: docker run コマンドが失敗しました。"
    echo "Dockerインストール後再起動を行っていない場合は、再起動を行ってください。"
    echo "また、 docker info の出力も確認してください。"
    exit /b 1
) else (
    echo "%OK%: docker run は正常に実行されました"
)

rem VScode Check
set "extension_id=ms-vscode-remote.remote-containers"
set "extension_label=拡張機能 Remote Containers (id: %extension_id% )"

where code >nul 2>&1
if errorlevel 1 (
    echo "Visual Studio Codeがインストールされているか確認してください。"
    echo "また、インストールされている場合、%extension_label%がインストールされているかも併せて確認して下さい。"
    exit /b 1
)

code --list-extensions | findstr /i "%extension_id%" >nul
if errorlevel 1 (
    echo "%extension_label%がインストールされていません。"
    echo "インストールコマンド: code --install-extension %extension_id%"
    exit /b 1
) else (
    echo "%OK%: Visual Studio Code & 拡張機能のインストール完了"
)

echo "完了！"
echo "事前セットアップ確認スクリプトによる確認が完了しました！"
