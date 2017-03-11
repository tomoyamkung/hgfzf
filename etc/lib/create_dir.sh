#!/bin/bash -eu

function usage_create_dir() {
  cat <<EOF 1>&2
Description:
  ディレクトリを作成する関数を定義したライブラリ。
  指定したディレクトリの存在確認を行い、存在する場合は何もしない。
  引数の確認は行わないので注意すること。

Usage:
  $(basename ${0}) /path/to/dir

Params:
  /path/to/dir    作成したいディレクトリのパス
EOF
  exit 0
}

function create_dir() {
  if [[ -d "${1}" ]]; then
    return 1  # ディレクトリが存在していたので何もしない
  fi

  mkdir -p "$1"
  return 0
}
