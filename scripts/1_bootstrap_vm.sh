#!/bin/bash

set -e

# Only run this script if KDIR=1 has been set
if [ -z $KDIR ]; then
  echo "Bailing, kernel directory not set."
  echo "Please rerun with KDIR=/path/to/kernel to run this script"
  exit 1
fi

DIR=${DIR:-"`mktemp -d`"}
CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
CONF_DIR=$CURRENT_DIR/../config
IMG=${IMG:-"qemu-image.img"}
ARCH=${ARCH:-"`uname -m`"}
DISK_SIZE=${DISK_SIZE:-"20g"}
KDIR=${KDIR:-"~/net-next"}
QEMU_PIDFILE=$CONF_DIR/qemu.pid

# Prevent duplicate runs.
if [ -f $QEMU_PIDFILE ]; then
  echo "ERROR: found pidfile for qemu. There should not be multiple runs from same workspace."
  echo "Please run this in a pristine environment or delete the file $QEMU_PIDFILE"
  exit 1
fi

function create_qemu_image() {
  BASE_PACKAGES="ssh,sudo,git,make,bash,ruby,vim,flex,bison,libelf-dev"
  qemu-img create $IMG $DISK_SIZE
  mkfs.ext4 $IMG
  sudo mount -o loop $IMG $DIR

  # Get the base system
  if [[ "$ARCH" == "aarch64" ]]; then
    sudo debootstrap --include=$BASE_PACKAGES --arch arm64 xenial $DIR
  elif [[ "$ARCH" == "x86_64" ]]; then
    sudo debootstrap --include=$BASE_PACKAGES --arch amd64 xenial $DIR
  fi

  # Setup user and ssh directory
  sudo chroot $DIR useradd -m -s /bin/bash ubuntu
  sudo chroot $DIR adduser ubuntu sudo
  sudo chroot $DIR bash -c 'echo ubuntu:free | chpasswd'
  sudo chroot $DIR mkdir -pv /home/ubuntu/.ssh
  sudo chroot $DIR chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  sudo chroot $DIR bash -c 'echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers'
  # Copy the configuration files
  sudo cp $CONF_DIR/xenial.sources.list $DIR/etc/apt/sources.list
  sudo cp $CONF_DIR/modules $DIR/etc/modules
  #sudo cp $CONF_DIR/fstab $DIR/etc/fstab
  sudo cp $CONF_DIR/interfaces $DIR/etc/network/interfaces
  sudo cp /etc/resolv.conf $DIR/etc/resolv.conf

  #sudo chroot $DIR git clone https://github.com/intel/lkp-tests.git /src/lkp-tests
  sudo chroot $DIR git clone --branch staging https://github.com/scanf/lkp-tests.git /src/lkp-tests
  sudo chroot $DIR useradd -m -s /bin/bash lkp
  sudo chroot $DIR make -C /src/lkp-tests install
  sudo chroot $DIR /usr/local/bin/lkp install

  sudo make -C $KDIR modules_install INSTALL_MOD_PATH=$DIR
  sudo make -C $KDIR headers_install INSTALL_HDR_PATH=$DIR/usr/

  # Prepare the host SSH and user
  cp ~/.ssh/id_rsa.pub $CONF_DIR/authorized_keys
  sudo cp $CONF_DIR/authorized_keys $DIR/home/ubuntu/.ssh/
  sudo chroot $DIR chown -R ubuntu:ubuntu /home/ubuntu
}

function boot_image() {
  # https://superuser.com/questions/885414/linux-command-get-unused-port
  PORT=`ruby -e 'require "socket"; puts Addrinfo.tcp("", 0).bind {|s| s.local_address.ip_port }'`
  echo $PORT > $CONF_DIR/ssh_port

  QEMU_BINARY=${QEMU_BINARY:-"qemu-system-$ARCH"}
  KERNEL_IMAGE=${KERNEL_IMAGE:-"$KDIR/arch/$ARCH/boot/bzImage"}
  EXTRA_OPTS=""

  if [[ "$ARCH" == "aarch64" ]]; then
    KERNEL_IMAGE="$KDIR/arch/arm64/boot/Image"
    EXTRA_OPTS=" -cpu host -M virt"
  fi

  $QEMU_BINARY $EXTRA_OPTS \
    -drive format=raw,file=$IMG \
    -kernel $KERNEL_IMAGE \
    -append "root=/dev/sda rw console=ttyS0" \
    --enable-kvm \
    --nographic \
    -localtime \
    -device e1000,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::$PORT-:22 \
    -m 4096 \
    -pidfile $QEMU_PIDFILE \
    -smp 2 & # Run QEMU in the background
}

if [ $SKIP_IMAGE != 1 ]; then
  function cleanup() {
    echo "cleanup()"
    sudo umount $DIR
    rmdir $DIR
  }
  trap cleanup exit
  create_qemu_image
fi
boot_image

# TODO: seperate script for running the tests
# TODO: seperate script for getting the test results.
# TODO: sudo lkp run jobs/test_bpf.yaml
# sudo lkp run jobs/kernel_selftests.yaml
