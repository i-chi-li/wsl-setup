#!/usr/bin/env bash

set -ue

apt-get update
apt-get -y upgrade

apt-get install -y \
  neovim \
  ripgrep \
  unzip \
  ccache \
  cmake \
  ninja-build \
  libtool \
  build-essential \
  clang-12 \
  mingw-w64 \
  python3-dev \
  python3-pip

# clang を alternatives で管理できるように登録
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-12 120 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-12
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 120
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 120

# ccache の設定
ccache --config-path /etc/ccache.conf --max-size 5G
for p in gcc g++ cc c++ clang clang++; do ln -vs /usr/bin/ccache /usr/local/bin/$p; done
hash -r

# Go 言語をインストール
wget https://go.dev/dl/go1.19.2.linux-amd64.tar.gz
rm -rf /usr/local/go
tar -C /usr/local -xzf go1.19.2.linux-amd64.tar.gz

echo export PATH=\$PATH:/usr/local/go/bin > /etc/profile.d/golang.sh
