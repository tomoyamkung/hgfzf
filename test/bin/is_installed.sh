#!/bin/bash -eu

# テスト対象のスクリプトを読み込む
. ~/hgfzf/bin/`echo $(basename ${0})`

is_installed ls || echo "ls はインストールされています"
is_installed dummy && echo "dummy はインストールされていません"
