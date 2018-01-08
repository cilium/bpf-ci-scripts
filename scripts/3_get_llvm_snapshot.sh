#!/bin/bash

set -xe

RETRY=180s

for i in $(seq 1 3); do
  wget -P /tmp/ https://apt.llvm.org/llvm-snapshot.gpg.key || (sleep $RETRY && continue)
  break
done

sudo apt-key add /tmp/llvm-snapshot.gpg.key

echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" | sudo tee -a /etc/apt/sources.list

for i in $(seq 1 3); do
  sudo apt-get update || (sleep $RETRY && continue)
  sudo apt-get -y install clang-6.0 lldb-6.0 lld-6.0 || (sleep $RETRY && continue)
  sudo apt-get install -f -y
done

/usr/bin/llc-6.0 --version
/usr/bin/clang-6.0 --version
