#!/bin/bash -eu

# プロジェクトのルートディレクトリを設定する
if [[ -z "${DOTPATH:-}" ]]; then
  DOTPATH=~/mercurial_tools
  export DOTPATH
fi

# ライブラリファイルを読み込む
. ${DOTPATH}/bin/is_installed.sh
. ${DOTPATH}/bin/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は lua をインストールするスクリプトである。
  lua は yum を使ってインストールする。
  lua をインストールする目的は Vim にある。
  有用な Vim プラグインをインストールする際に lua が必要なことがあるため lua を有効にした状態で Vim をインストールする。

Usage:
  $(basename ${0}) [-h] [-x]

Options:
  -h print this
  -x dry-run モードで実行する
EOF
  exit 0
}

while getopts hx OPT
do
  case "$OPT" in
    h) usage ;;
    x) enable_dryrun ;;
    \?) usage ;;
  esac
done


# lua がインストールされている場合は処理を終了する
is_installed lua && exit 1

# `yum` を使って lua をインストールする
${dryrun} sudo yum -y install lua

# `yum` を使って lua-devel をインストールする
${dryrun} sudo yum -y install lua-devel

exit 0
