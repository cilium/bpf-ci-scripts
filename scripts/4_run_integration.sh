#!/bin/bash

set -x#e

cd ~/go/src/github.com/cilium/cilium
make
sudo make install
cd -
sudo integration/run-tests
