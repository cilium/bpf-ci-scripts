#!/bin/bash

set -xe

KDIR=$1 # Kernel tree
TEST_DIR=$KDIR/tools/testing/selftests/bpf/

set +e
(cd $KDIR/tools/bpf/bpftool/ && make && sudo make install) || true
if ! test -d $TEST_DIR; then
  echo "XXX: could not find BPF selftests at $TEST_DIR, maybe too old kernel?"
  echo "XXX: Aborting run selftest"
  exit 0
fi
set -e
