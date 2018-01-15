#!/bin/bash

set -e

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $CURRENT_DIR/sshutil.sh

CLONE_CMD="git clone -b `cat $CURRENT_DIR/../config/iproute2_branch` git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git /tmp/iproute2"
COMPILE_IPROUTE2="cd /tmp/iproute2/ && \
./configure --prefix=/usr && \
make -j 2 && \
sudo make install && ip -V"

echo $CLONE_CMD |$SSH_CMD
echo $COMPILE_IPROUTE2 |$SSH_CMD
