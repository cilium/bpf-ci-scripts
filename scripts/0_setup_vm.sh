#!/bin/bash

set -xe

# Get the scripts
git clone https://github.com/scanf/bpf-ci-scripts workspace || true
git -C workspace checkout . || true
git -C workspace pull origin master || true

# Vagrant setup
cp workspace/Vagrantfile Vagrantfile
vagrant plugin install vagrant-reload
vagrant plugin install vagrant-scp

# Build artificats directory
mkdir -pv ARTIFACTS

# Start the VM
vagrant up
