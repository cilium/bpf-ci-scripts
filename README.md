# BPF CI scripts

The Jenkinsfile is crafted to work with a kernel tree. It relies on Vagrant for
the VM. The scripts mainly does the following

1. Clone or fetch this repository from GitHub
2. Copy the Vagrantfile and VM related steps 
3. Run stages
   - Install latest LLVM snapshot in newly booted kernel
   - Run Cilium tests (skipped)
   - Run BPF selftest with LLVM versions 3.8.1 - 5.0.0 and snapshot.
4. Get artificats and cleanup
5. Send email 

Setting a Jenkins instance to use this setup is pretty straightforward using
the multibranch plugin from below. The other plugins needed for Vagrant are
installed via the Jenkinsfile.

This currently only works with x86\_64 but support for ARM64 is being worked
on.

## Jenkins plugins

- [Pipeline: Multibranch with defaults](https://plugins.jenkins.io/pipeline-multibranch-defaults)
- [Email-ext plugin](https://wiki.jenkins.io/display/JENKINS/Email-ext+plugin)
- [Pipeline](https://plugins.jenkins.io/workflow-aggregator)

## Vagrant plugins

- [vagrant-reload](https://github.com/aidanns/vagrant-reload)
- [vagrant-scp](https://github.com/invernizzi/vagrant-scp)

## Credits

These files are based on other ones, mostly copied from the below ones

- https://github.com/cilium/cilium/blob/master/Jenkinsfile
- https://github.com/tgraf/net-next-vagrant
