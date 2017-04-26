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
  $(basename ${0}) は以下のディレクトリ配下にあるインストールスクリプトを実行するスクリプトである。
    - etc/install/**/*.sh

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

for script in `find "${DOTPATH}/etc/install" -type f -name "*.sh"`
do
  ${dryrun} sh ${script}
done

exit 0
