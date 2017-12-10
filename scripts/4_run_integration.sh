#!/bin/bash

echo TODO enable 4_run_integration

exit 0
set -xe

cd ~/go/src/github.com/cilium/cilium
make
sudo make install
cd -
sudo integration/run-tests # TODO: < Verify this path
