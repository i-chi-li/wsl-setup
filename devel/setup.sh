#!/usr/bin/env bash

set -ue

apt-get update
apt-get -y upgrade

apt-get install -y \
  neovim \
  ripgrep \
  unzip \
  ccache \
  checkinstall \
  cmake \
  gettext \
  ninja-build \
  libtool \
  pkg-config \
  nasm \
  yasm \
  build-essential \
  clang-12 \
  mingw-w64 \
  mingw-w64-tools \
  python3-dev \
  python3-pip \
  wine

# clang を alternatives で管理できるように登録
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-12 120 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-12
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 120
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 120

# ccache の設定
for p in cc c++ clang clang++; do ln --force --verbose --symbolic ../../bin/ccache /usr/lib/ccache/$p; done
hash -r

# Go 言語をインストール
golang_ver=1.19.2
if [ ! -f go${golang_ver}.linux-amd64.tar.gz ]; then
  wget https://go.dev/dl/go${golang_ver}.linux-amd64.tar.gz
fi
rm -rf /usr/local/go
tar -C /usr/local -xzf go${golang_ver}.linux-amd64.tar.gz

if [ ! -f /etc/profile.d/golang.sh ]; then
  echo export PATH=\$PATH:/usr/local/go/bin > /etc/profile.d/golang.sh
  source /etc/profile.d/golang.sh
fi

echo setup completed.
