#!/bin/bash

set -x

export 'IPROUTE_BRANCH'=${IPROUTE_BRANCH:-"net-next"}

cd $HOME/workspace

cp /boot/config-`uname -r` .config
yes '' | make oldconfig
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
./scripts/config --module CONFIG_TEST_BPF
./scripts/config --disable CONFIG_LUSTRE_FS

# make and install latest kernel
make -j `getconf _NPROCESSORS_ONLN` LOCALVERSION=-custom

# clean all old kernels
sudo rm -Rf /lib/modules/*
sudo rm /boot/*

sudo make modules_install
sudo make install
sudo make headers_install INSTALL_HDR_PATH=/usr/

# Temporary hack for Ubuntu
sudo cp /usr/include/asm/unistd* /usr/include/x86_64-linux-gnu/asm/
echo 9p | sudo tee --append /etc/modules
echo 9pnet_virtio | sudo tee --apend /etc/modules
echo 9pnet | sudo tee --append /etc/modules

# iproute2 installation
cd $HOME
git clone -b "${IPROUTE_BRANCH}" git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git
cd iproute2/
./configure
make -j `getconf _NPROCESSORS_ONLN`
sudo make install
