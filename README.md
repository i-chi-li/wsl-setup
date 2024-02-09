# WSL 環境構築用
WSL 環境を構築するための設定集。
Ubuntu 22.04 を利用する前提とする。

# 初期設定

WSL のデフォルトバージョンを 2 にする。
これは、一度のみ実行すればよい。

```
wsl --set-default-version 2
```

利用可能なディストリビューションを確認する。

```
wsl --list --online
```

# 環境のひな形を作成する
WSL では、同一ディストリビューションで複数の仮想環境を作成するには、エクスポート・インポートを行う必要がある。
（なぜこんな仕様なのか・・・）
初期状態から、ひな形を作成するので、既存の環境を一度削除することになるため注意。
ひな形は、一度作成すれば、使い回し可能だが、定期的に作成し直した方が良い。

```
# 必要に応じて既存の環境を削除する
wsl --unregister Ubuntu-22.04

# 環境をインストールする
wsl --install --distribution Ubuntu-22.04

# 一般ユーザを追加
Enter new UNIX username: ubuntu
New password:
Retype new password:

# ビープ音を抑制
echo "set bell-style none" >> ~/.inputrc
echo "set visualbell t_vb=" >> ~/.vimrc

# リポジトリを日本に変更
sudo sed -i.bak -r 's@http://(jp.)?archive.ubuntu.com/ubuntu/@http://jp.archive.ubuntu.com/ubuntu/@g' /etc/apt/sources.list

# パッケージをアップデート
sudo apt-get -y update
sudo apt-get -y upgrade

# cloud-init をインストール
sudo apt-get -y install cloud-init
exit

# ベース環境をエクスポート（出力先は任意のディレクトリで問題なし）
mkdir C:\WSL_data
cd /D C:\WSL_data
wsl --export Ubuntu-22.04 Ubuntu-22.04.tar
```

# WSL ディストリビューションのホスト名を変更する（任意）
WSL ディストリビューションのホスト名を変更したい場合、
[devel/user-data](devel/user-data) ファイルの `hostname = Ubuntu-devel` の行を変更する。

# /etc/resolv.conf ファイルを設定する（任意）
/etc/resolv.conf ファイルを自動生成ではなく任意に設定する場合、
[devel/user-data](devel/user-data) ファイルの
`#generateResolvConf = false` の行をコメントインし、
`#- path: /etc/resolv.conf` 以降の行をコメントインし、任意に変更する。

DNS を任意に指定したくなる要因として、WSL でネットワーク通信ができない場合などでは、
ESET などのウィルス対策ソフトが通信を遮断している場合がある、
その場合、ウィルス対策ソフトの設定で、該当の通信ブロックを解除することで、正常に通信ができることがある。

# 環境を構築する

```
# ひな形を保存したディレクトリに移動する
cd /D C:\WSL_data

# 必要に応じて既存の環境を削除
wsl --unregister Ubuntu-22.04-devel

# エクスポートした Ubuntu 環境から新環境を作成する
wsl --import Ubuntu-22.04-devel Ubuntu-22.04-devel Ubuntu-22.04.tar

# 作成した仮想環境をデフォルトにする場合は実行する
wsl --set-default Ubuntu-22.04-devel

# cloud-init で環境を構築する
wsl -d Ubuntu-22.04-devel

# このプロジェクトの devel ディレクトリに移動する
cd /mnt/d/IntelliJ-projects/wsl-setup/devel/
./cloud-init.sh
exit

# WSL をシャットダウンさせないと、ubuntu ユーザでのログインに切り替わらない
wsl --shutdown
```

## cloud-init を再実行する場合


```
# このプロジェクトの devel ディレクトリに移動する
cd /mnt/d/IntelliJ-projects/wsl-setup/devel/
sudo cloud-init clean --logs

# go 言語のアップデートをする場合
sudo rm -rf /usr/local/go

sudo ./cloud-init.sh
```
