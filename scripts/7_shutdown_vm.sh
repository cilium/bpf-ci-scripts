#!/bin/bash

set -e

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CONF_DIR=$CURRENT_DIR/../config

QEMU_PID=`cat $CONF_DIR/qemu.pid`
kill -9 $QEMU_PID
rm $CONF_DIR/qemu.pid
