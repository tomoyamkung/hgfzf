#!/bin/bash -eu

# プロジェクトのルートディレクトリを設定する
if [[ -z "${DOTPATH:-}" ]]; then
  DOTPATH=~/mercurial_tools
  export DOTPATH
fi

# ライブラリファイルを読み込む
. ${DOTPATH}/bin/create_dir.sh
. ${DOTPATH}/bin/dry_run.sh

function usage() {
  cat <<EOF 1>&2
Description:
  $(basename ${0}) は以下のディレクトリにあるシェルスクリプトのシンボリックリンクを作成するスクリプトである。
    - bin/mercurial/
  シンボリックリンクの作成先ディレクトリは以下とする（ディレクトリが存在しない場合は作成する）。
    - ~/bin/mercurial

Usage:
  $(basename ${0}) [-h] [-x]

Options:
  -h  print this
  -x  dry-run モードで実行する
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

# 設定ファイルを読み込む
. ${DOTPATH}/etc/config/deploy_config.sh

# シンボリックリンクの作成先ディレクトリを作成する
${dryrun} create_dir ${MERCURIAL_DIRECTORY}

for script in `find ${DOTPATH}/bin/mercurial -type f -name "*.sh"`
do
  x=`echo ${script} | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}'`  # スクリプトファイル名を抜き出す
  ${dryrun} ln -sf ${script}  ${MERCURIAL_DIRECTORY}/${x}
done
exit 0
