# WSL 環境構築用
個人的な WSL 環境を構築するためのスクリプト集。

# WSL 環境の準備
WSL 環境の準備は、手動で実施する。

## WSL のデフォルトバージョンを 2 にする
これは、一度のみ実行すればよい。

```
wsl --set-default-version 2
```

## ひな形とする Ubuntu-20.04 環境を準備する
ひな形は、一度作成すれば、使い回し可能。

Ubuntu-20.04 ディストリビューションを複数環境作成する場合、
一度、既存の環境をエクスポートして、取り込む必要がある。
（なぜこんな仕様なのか・・・）
初期状態から、ひな形を作成したいので、
デフォルトでインストールされる Ubuntu-20.04 環境を
一度削除するので注意。

### Ubuntu-20.04 環境を削除する

```
wsl --unregister Ubuntu-20.04
```

### Ubuntu-20.04 環境をインストールする

```
wsl --install --distribution Ubuntu-20.04
```

### Ubuntu-20.04 環境の初期設定を行う

環境が起動すると、別ウィンドウが開き、
ログインユーザIDとパスワードを聞かれるので、任意に設定する。

```shell
sudo sed -i.bak -r 's@http://(jp.)?archive.ubuntu.com/ubuntu/@http://jp.archive.ubuntu.com/ubuntu/@g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y upgrade
exit
```

### Ubuntu-20.04 環境をひな形としてエクスポート

ひな形の格納と、新規環境を保存するための、
任意のディレクトリを作成し、ひな形をエクスポートする。
ここでは、```C:\WSL_data``` とする。

```
mkdir C:\WSL_data
cd /D C:\WSL_data
wsl --export Ubuntu-20.04 Ubuntu-20.04.tar
```

## 新環境を構築する

### ひな形をインポートして新環境を作成する

```
wsl --import Ubuntu-20.04-build Ubuntu-20.04-build Ubuntu-20.04.tar
wsl --set-default Ubuntu-20.04-build
```

### 新環境を起動する

新環境を起動してログインする。

```
wsl --distribution Ubuntu-20.04-build
```

### 初期設定をする

デフォルトユーザを ```ubuntu```、PATH に Windows 側の PATH を追加しないように設定。

```shell
cat << EOF > /etc/wsl.conf
[user]
default=ubuntu
[interop]
appendWindowsPath=false
EOF
exit
```

### 新環境を再起動する

新環境を再起動し、ログインする。

```
wsl --terminate Ubuntu-20.04-build
wsl --distribution Ubuntu-20.04-build
```

### 新環境を設定する

```shell
cd
wget https://github.com/i-chi-li/wsl-setup/raw/master/devel/setup.sh
sudo bash setup.sh
```
