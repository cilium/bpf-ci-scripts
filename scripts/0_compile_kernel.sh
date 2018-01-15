#!/bin/bash

set -xe

# Only run this script if KDIR=1 has been set
if [ -z $KDIR ]; then
  echo "Bailing, kernel directory not set."
  echo "Please rerun with KDIR=/path/to/kernel to run this script"
  exit 1
fi

# Figure out which iproute2 version to use.
export 'IPROUTE_BRANCH'=${IPROUTE_BRANCH:-"net-next"}
if grep bpf.git .git/config; then
  export IPROUTE_BRANCH="master"
elif grep linux-stable.git .git/config; then
  export IPROUTE_BRANCH="master"
fi
CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CONF_DIR=$CURRENT_DIR/../config
mkdir -pv $CONF_DIR
echo $IPROUTE_BRANCH > $CONF_DIR/iproute2_branch

export 'CONCURRENT'=${CONCURRENT:-"4"}

# Prepare the kernel configuration
cd $KDIR
make clean
rm .config || true
make defconfig
./scripts/config --enable BPF_JIT_ALWAYS_ON
./scripts/config --disable CONFIG_DEBUG_INFO
./scripts/config --disable CONFIG_DEBUG_KERNEL
./scripts/config --enable CONFIG_BPF
./scripts/config --enable CONFIG_BPF_SYSCALL
./scripts/config --module CONFIG_NETFILTER_XT_MATCH_BPF
./scripts/config --module CONFIG_NET_CLS_BPF
./scripts/config --module CONFIG_NET_ACT_BPF
./scripts/config --enable CONFIG_BPF_JIT
./scripts/config --enable CONFIG_HAVE_BPF_JIT
./scripts/config --enable CONFIG_BPF_EVENTS
./scripts/config --enable BPF_STREAM_PARSER
./scripts/config --module CONFIG_TEST_BPF
./scripts/config --disable CONFIG_LUSTRE_FS
./scripts/config --enable CONFIG_CGROUP_BPF
./scripts/config --module CONFIG_NET_SCH_INGRESS
./scripts/config --enable CONFIG_NET_CLS_ACT
./scripts/config --enable CONFIG_LWTUNNEL_BPF
./scripts/config --enable CONFIG_HAVE_EBPF_JIT
./scripts/config --module CONFIG_NETDEVSIM
./scripts/config --enable BPF_KPROBE_OVERRIDE

# Build the kernel
make -j $CONCURRENT LOCALVERSION=-custom
make modules
