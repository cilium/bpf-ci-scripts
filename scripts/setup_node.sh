#!/bin/bash

sudo apt-get update
sudo apt-get install ruby qemu debootstrap git make gcc libssl-dev bc libelf-dev \
libcap-dev llvm libncurses5-dev git pkg-config bison flex qemu-kvm \
libvirt-bin virtinst bridge-utils cpu-checker -y
