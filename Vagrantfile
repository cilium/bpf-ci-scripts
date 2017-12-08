# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "scanf/bpf-base"
  config.vm.box_version = "1"
  config.vm.provider "virtualbox" do |v|
    v.memory = 4096
    v.cpus = 4
  end
  config.vm.synced_folder '.', '/home/vagrant/workspace', type: "rsync"
end
