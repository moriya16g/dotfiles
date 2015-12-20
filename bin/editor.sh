#!/usr/bin/sh

# cygwin コマンドラインから windows 系エディタを、引数のファイルを Windows 系のパスに変換してから、実行する
FILE=`cygpath -w "${1}"`
"c:/APPZ/vim/gvim.exe" "$FILE"
