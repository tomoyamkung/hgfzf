# mercurial_tools

mercurial_tools とは Mercurial をリポジトリとした開発作業で使用する `hg` コマンドをラップするスクリプトを提供するプロジェクトである。  
ブランチの手入力を出来るだけ抑えることを目的としており [fzf](https://github.com/junegunn/fzf) を使ったフィルタリングでブランチを特定するようになっている。


# セットアップ手順

セットアップ手順は以下の通り。

```
$ git clone https://github.com/tomoyamkung/mercurial_tools.git
$ cd mercurial_tools
$ ./etc/install.sh  # 本プロジェクトが提供する機能に必要なソフトウェアのインストールを行う
$ ./etc/deploy.sh  # 本プロジェクトが提供する機能を設定にする
$ . ~/.bashrc
```


# 仕様・制限事項

本プロジェクトの仕様、および、制限事項は以下の通り。

- 本プロジェクトは CentOS で開発され CentOS 上での使用を想定しているため、基本的に CentOS 以外での使用は考慮していない
- Mercurial は既に環境にインストールされている状態とする
- 同様に Git も既に環境にインストールされている状態とする
- `hg` コマンドをラップするスクリプトは clone したディレクトリ配下にある状態とし ~/bin/mercurial/ ディレクトリにシンボリックリンクを作成する
    - 任意のディレクトリに変更可能
- シェルは bash を対象とし、本プロジェクトが提供する機能の設定は ~/.bashrc に追記する
- fzf のインストールディレクトリは以下とする
    - ~/.fzf


# hg コマンドをラップするスクリプトについて

etc/deploy.sh を実行すると ~/bin/mercurial/ ディレクトリに以下のシンボリックリンクが作成される。

```
$ ll ~/bin/mercurial
:
... hcb -> /path/to/mercurial_tools/bin/mercurial/hcb.sh
... hme -> /path/to/mercurial_tools/bin/mercurial/hme.sh
... hpu -> /path/to/mercurial_tools/bin/mercurial/hpu.sh
... hst -> /path/to/mercurial_tools/bin/mercurial/hst.sh
... hup -> /path/to/mercurial_tools/bin/mercurial/hup.sh
```

各スクリプトのサマリは以下の通り。
詳しくは各スクリプトの `usage()` を参照のこと。

- hcb.sh: `hg commit --close-branch` を実行する
- hme.sh: `hg merge` を実行する
- hpu.sh: `hg push - BRANCH_NAME` を実行する
- hst.sh: 主にプロジェクトの状態を確認する
- hup.sh: `hg update` を実行する

