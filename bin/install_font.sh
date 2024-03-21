#!/bin/bash

# エラーが発生した場合にスクリプトを終了させる
set -e

# ダウンロードするファイルのURL
URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip"
# ファイル名をURLから抽出
FILENAME="${URL##*/}"
# ファイルを保存するディレクトリ
DOWNLOAD_DIR="$HOME/Downloads"
# 展開したフォントを保存するディレクトリ（macOS用に変更）
FONT_DIR="$HOME/Library/Fonts"
# ダウンロードするフォントの名前
FONT_NAME="Roboto Mono Regular"

# ダウンロードディレクトリに移動
cd $DOWNLOAD_DIR

# ファイルのダウンロード（macOS用に変更）
curl -L $URL -o "$FILENAME"

# ファイルの解凍
unzip "$FILENAME"

# フォントディレクトリの存在確認、存在しなければ作成
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$FONT_DIR"
fi

# フォントファイルをフォントディレクトリにコピー
find . -name "*$FONT_NAME*.ttf" -exec cp {} $FONT_DIR \;

echo "$FONT_NAME font has been installed."

