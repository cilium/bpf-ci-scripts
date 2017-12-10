#!/bin/bash

set -xe

function run_selftest() {
  export PATH=$1/bin:$PATH
  make
  sudo ./test_verifier
  sudo make run_tests
  make clean
}

KDIR=$1 # Kernel tree

cd $KDIR
make headers_install

cd $KDIR/tools/bpf/bpftool/
make
sudo make install

cd $KDIR/tools/testing/selftests/bpf/

# Used the preinstalled ones from VM image
CLANG_VERSIONS=("5.0.0" "4.0.0" "3.9.1" "3.9.0" "4.0.1")
for c in ${CLANG_VERSIONS[@]}; do
  run_selftest "/usr/local/clang+llvm-$c"
done

# Used the compiled version
run_selftest "/src/llvm/build"
