#!/bin/bash -eu

# プロジェクトのルートディレクトリを設定する
if [[ -z "${DOTPATH:-}" ]]; then
  DOTPATH=~/hgfzf
  export DOTPATH
fi

# ライブラリファイルを読み込む
. ${DOTPATH}/bin/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は "hg commit --close-branch" を実行するスクリプトである。
  ブランチを閉鎖する際のコミットメッセージはデフォルトで以下の形式となっている。
    - close branch BRANCH_NAME
  コミットメッセージを変更する場合は -m オプションを指定する。
    - コミットメッセージが空白を含む場合はクォートで囲むこと
  ブランチを閉鎖後に "hg push" を実行したい場合は -p オプションを指定する。

Usage:
  $(basename ${0}) [-h] [-m commit_message] [-p] [-x]

Options:
  -h  print this
  -m  ブランチを閉鎖する際のコミットメッセージを指定する
  -p  ブランチを閉鎖後に "hg push" を実行する
  -x  dry-run モードで実行する
EOF

  exit 0
}

commit_message=""
is_push=
while getopts hm:px OPT
do
  case "$OPT" in
    h) usage ;;
    m) commit_message="$OPTARG" ;;
    p) is_push=true ;;
       # ブランチを閉鎖後に `push` するかを制御する識別子
       # この変数に値が格納されている場合は `push` する
    x) enable_dryrun ;;
    \?) usage ;;
  esac
done

# FZF を使ってブランチを絞り込む
branch_name=$(hg branches | fzf --exit-0 --select-1 --ansi)
# 存在しないブランチを指定された場合は処理を終了する
if [[ -z ${branch_name} ]]; then
  exit 1
fi
# 不要な文字を取り除く
branch_name=$(echo ${branch_name} | awk '{print $1}')

# コミットメッセージが未設定の場合はデフォルトを設定する
if [[ -z "${commit_message}" ]]; then
  commit_message="close branch ${branch_name}"
fi

# `hg update` を実行する
${dryrun} hg update "${branch_name}"
# 指定したブランチを閉鎖する
${dryrun} hg commit --close-branch -m "${commit_message}"
# -p オプションが指定されたので `push` する
if [[ ! -z "${is_push}" ]]; then
  ${dryrun} hg push
fi

exit 0
