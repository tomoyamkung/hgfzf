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
  $(basename ${0}) は "hg push -b BRANCH_NAME" を実行するスクリプトである。
  デフォルトでは "hg push -b BRANCH_NAME" を実行するが、-a オプションを指定すると "hg push" を実行する。
  新規に作成したブランチを push する場合 "hg push --new-branch" とする必要があるが、そのオプションは自動で付与するようになっている。
  push するブランチは FZF により絞り込んで指定するため $(basename ${0}) の引数には指定しない。

Usage:
  $(basename ${0}) [-a] [-h] [-x]

Options:
  -a  ブランチを指定せずに "hg push" を実行する
  -h  print this
  -x  dry-run モードで実行する
EOF
  exit 0
}

b_option=-b  # `hg update` のオプション。デフォルトは -b
while getopts ahx OPT
do
  case "$OPT" in
    a) b_option=  # -a オプションが指定されたのでブランクを設定する
       ;;
    h) usage ;;
    x) enable_dryrun ;;
    \?) usage ;;
  esac
done

branch_name=  # ブランチ名を格納する。-a オプションが指定されない場合は後続処理で絞り込む
# -a オプションが指定された場合はブランチを絞り込まない
if [[ ! -z ${b_option} ]]; then
  # FZF を使ってブランチを絞り込む
  branch_name=$(hg branches | fzf --exit-0 --select-1 --ansi)
  # 存在しないブランチを指定された場合は処理を終了する
  [[ -z ${branch_name} ]] && exit 2
  branch_name=$(echo ${branch_name} | awk '{print $1}')
fi

# `hg update` を実行する
${dryrun} hg push ${command_option} ${branch_name}
if [[ $? -eq 0 ]]; then
  exit 0
fi
# 失敗した場合は `--new-branch` を付与して再度実行する
hg push --new-branch ${command_option} ${branch_name}
exit 0
