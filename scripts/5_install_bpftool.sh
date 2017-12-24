#!/bin/bash

set -xe

KDIR=$1 # Kernel tree
TEST_DIR=$KDIR/tools/testing/selftests/bpf/
BPFTOOL_DIR=$KDIR/tools/bpf/bpftool/

if ! test -d $BPFTOOL_DIR; then
  echo "XXX: could not find bpftool, maybe too old kernel?"
  exit 0
fi

cd $BPFTOOL_DIR
make
sudo make install
