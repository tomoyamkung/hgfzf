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
  $(basename ${0}) は "hg update" を実行するスクリプトである。
  "hg update" 自体のオプションは受け付けない。
  "hg update ブランチ名" としてブランチを移動する目的で使用する。
  移動先のブランチは FZF により絞り込んで指定するため $(basename ${0}) の引数には指定しない。

Usage:
  $(basename ${0}) [-c] [-h] [-x]

Options:
  -c  close されたブランチも対象とする
  -h  print this
  -x  dry-run モードで実行する
EOF
  exit 0
}

close_branch=
while getopts chx OPT
do
  case "$OPT" in
    c) close_branch="-c" ;;
    h) usage ;;
    x) enable_dryrun ;;
    \?) usage ;;
  esac
done

# FZF を使ってブランチを絞り込む
branch=$(hg branches ${close_branch} | fzf --exit-0 --select-1 --ansi)
# 存在しないファイルを指定された場合は処理を終了する
[[ -z ${branch} ]] && exit 1

branch=$(echo ${branch} | awk '{print $1}')
${dryrun} hg update ${branch}
exit 0
