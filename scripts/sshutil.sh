#!/bin/bash

set -ex

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

SSH_CMD="/usr/bin/ssh ubuntu@localhost -t -t -p `cat $CURRENT_DIR/../config/ssh_port`"
