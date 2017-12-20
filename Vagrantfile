# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # TODO: use box=cilium/ubuntu-16.10 when > v2.6.1 has been released
  config.vm.box = "scanf/bpf-base"
  config.vm.box_version = "4"
  config.vm.provider "virtualbox" do |v|
    v.memory = ENV['VM_MEMORY'].to_i
    v.cpus = ENV['VM_CPUS'].to_i
  end
  config.vm.boot_timeout = 5400
  config.vm.synced_folder '.', '/home/vagrant/workspace', type: "rsync"
  config.vm.provision :shell, :privileged => false, :path => "workspace/scripts/1_compile_kernel.sh"
  config.vm.provision :reload
end
