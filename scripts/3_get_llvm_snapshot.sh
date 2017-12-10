#!/bin/bash

set -xe

wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -

echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" | sudo tee -a /etc/apt/sources.list

sudo apt-get update
sudo apt-get -y install clang-6.0 lldb-6.0 lld-6.0
