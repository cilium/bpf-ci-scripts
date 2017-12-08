#!/bin/bash

set -x

KDIR=$1 # Kernel tree
cd $KDIR

make headers_install

cd tools/testing/selftests/bpf/
make
sudo ./test_verifier
sudo make run_tests
