#!/bin/bash

set -xe

export 'IPROUTE_BRANCH'=${IPROUTE_BRANCH:-"net-next"}
export 'KCONFIG'=${KCONFIG:-"config-`uname -r`"}

# Use env var to make it easier to test the files on workstations with
# different directory layout.
if [ -z $LOCAL_CHECK ]; then
  cp ~/workspace/workspace/scripts/.config .config
  cd $HOME/workspace
else
  cp ~/workspace/scripts/.config .config
  git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git $HOME/k || true
  cd $HOME/k
fi

if grep bpf.git .git/config; then
  export IPROUTE_BRANCH="master"
elif grep linux-stable.git .git/config; then
  export IPROUTE_BRANCH="master"
fi

make olddefconfig
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

# make and install latest kernel
make -j `getconf _NPROCESSORS_ONLN` LOCALVERSION=-custom

sudo make modules_install
sudo make install
sudo make headers_install INSTALL_HDR_PATH=/usr/

# iproute2 installation
cd $HOME
git clone -b "${IPROUTE_BRANCH}" git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git
cd iproute2/
./configure --prefix=/usr
make -j `getconf _NPROCESSORS_ONLN`
sudo make install
