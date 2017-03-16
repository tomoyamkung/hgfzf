#!/bin/bash -eu

# プロジェクトのルートディレクトリを設定する
if [[ -z "${DOTPATH:-}" ]]; then
  DOTPATH=~/mercurial_tools
  export DOTPATH
fi

# ライブラリファイルを読み込む
. ${DOTPATH}/bin/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は "hg merge" を実行するスクリプトである。
  マージされるブランチは FZF により絞り込んだものが指定される。
  ブランチをマージした後にコミットしたい場合は -c オプションを指定する。
  その際のコミットメッセージはデフォルトで以下の形式となっている。
    - merge BRANCH_NAME
  コミットメッセージを変更する場合は -m オプションを指定する。
    - コミットメッセージが空白を含む場合はクォートで囲むこと
  加えて、マージした後にプッシュしたい場合は -p オプションを指定する。
  p オプションは c オプションが指定されていない場合は無効となる。

Usage:
  $(basename ${0}) [-c] [-h] [-m commit_message] [-p] [-x]

Options:
  -c  ブランチをマージした後にコミットする
  -h  print this
  -m  c オプションを指定した際のコミットメッセージを指定する
  -p  c オプションを指定してコミットした後に "hg push" を実行する
  -x  dry-run モードで実行する
EOF

  exit 0
}

commit_message=""
is_push=
while getopts chm:px OPT
do
  case "$OPT" in
    c) is_ci=true ;;
       # ブランチをマージした後に `commit` するかを制御する識別子
       # この変数に値が格納されている場合は `commit` する
    h) usage ;;
    m) commit_message="$OPTARG" ;;
    p) is_push=true ;;
       # c オプションで `push` した後に `push` するかを制御する識別子
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
# 指定したブランチがカレントブランチだった場合は処理を終了する
if [[ ${branch_name} = `hg branch` ]]; then
  exit 2
fi

# `hg merge` を実行する
${dryrun} hg merge "${branch_name}"
# `hg merge` に失敗した場合は処理を中断する
if [[ 0 -ne $? ]]; then
  exit 3
fi

# c オプションが指定されていない場合は処理を終了する
if [[ -z "${is_ci}" ]]; then
  exit 0
fi

# コミットメッセージが未設定の場合はデフォルトを設定する
if [[ -z ${commit_message} ]]; then
  commit_message="merge ${branch_name}"
fi

# `hg ci` を実行する
${dryrun} hg ci -m "${commit_message}"
# `hg ci` に失敗した場合は処理を中断する
if [[ 0 -ne $? ]]; then
  exit 4
  fi

# p オプションが指定されていない場合は処理を終了する
if [[ -z "${is_push}" ]]; then
  exit 0
fi
# `hg push` を実行する
${dryrun} hg push
# `hg push` に失敗した場合はその旨の終了結果を返す
if [[ 0 -ne $? ]]; then
  exit 5
fi

exit 0
