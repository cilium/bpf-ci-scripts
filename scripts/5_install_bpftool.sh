#!/bin/bash

set -xe

KDIR=$1 # Kernel tree
TEST_DIR=$KDIR/tools/testing/selftests/bpf/

set +e
(cd $KDIR/tools/bpf/bpftool/ && make && sudo make install) || true
set -e
