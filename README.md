# BPF CI scripts

The [Jenkinsfile][0] is crafted to work with a kernel tree.
A rough overview of all the steps:

1. Clone or fetch this repository from GitHub
2. Copy the Vagrantfile and VM related steps 
3. Run stages
   - Install latest LLVM snapshot in newly booted kernel
   - Run Cilium tests (skipped)
   - Install bpftool
   - Run BPF selftest with LLVM version~~s 3.8.1 - 5.0.0 and~~ snapshot
4. Get artifacts and cleanup
5. Send notifications via email

This currently only works with x86\_64 but support for ARM64 is being worked
on.

## New Jenkins instance

Setting up a Jenkins instance to use this setup is pretty straightforward.  The
suggested plugins from the Jenkins community will cover most of the plugins but
to avoid issues check that the ones listed in [Jenkins plugins][1] are
installed. The regular tools like Git CLI, Virtualbox, and Vagrant are also
required.  Any of the missing plugins can cause weird error messages on
Jenkins, so check that first in case of errors.

When Jenkins is up and running with all the dependencies. Copy the contents of
[Jenkinsfile][0] and add it to [/configfiles][2] with the exact same name. For
screenshots on how do this see [vaimr/pipeline-multibranch-defaults-plugin][3]

Valid SMTP credentials must be setup for email notifications to work. Otherwise
it could cause a build failure.

## Adding a new tree

The following steps assume you have a Jenkins instance up with all of the
dependencies.  Also please keep in mind that fetching a kernel tree might take
10+ min., so let it timeout and retry if necessary.

To add a tree first create a new `Multibranch Pipeline with defaults` job by
visiting https://jenkins.cilium.io/view/all/newJob

From the `General` tab under `Branch Sources` use `Add source` to select Git,
there you can enter the project repository (git URL) and if necessary add a
filter.  Make sure the `Build Configuration` section has the mode set to `by
default Jenkinsfile`.  It's also recommended to pick a `Orphaned Item
Strategy`, f. ex.  only keep 1-3 builds.

If the new tree is very similar to a existing job, the copy job feature could
be used. Then you would just have to modify the relevant fields instead.

Why use a filter? In the linux-stable tree case a lot of branches are outdated
and not relevant so a expression like this
`^(master|linux-3\.18|linux-4\.4|linux-4\.9|linux-4\.14).*`
is enough to ignore the old ones.

## Maintenance

This setup currently relies on Vagrant, the [cilium/packer-ubuntu-16.10][4]
image and [LLVM repositories][5]. Things are working most of the time on x86\_64
but there are some known flakes.

- One of the stages installs the latest LLVM snapshot and at times there are
  network issues with apt. The cause for this has not been determined.
- The VM base image has not caused any issues but it's worth noting that any
changes there is a separate process and requires getting changes merged in that
repository and there might be a delay for VM image changes to take affect.
- If the disk space gets full the tests could start failing or issues with SCM
triggered builds not being started.

Another thing that might be confusing is the directory layout. Since the kernel
does not have a Jenkinsfile one is added globally under the
[/configfiles][2].  Whenever this file is modified the changes have
to be approved manually in [/scriptApproval][6].  The Jenkinsfile
is not edited often so it's not a big issue. Since part of the build stage is
fetching recent changes from this repository, the contents from  scripts/ is
copied over. To avoid conflicts with the kernel the scripts directory a prefix
is used `workspace/scripts`. The paths in the Jenkinsfile using
the scripts from the VM need to have the right prefix.

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

[0]: ./jenkins/Jenkinsfile
[1]: #jenkins-plugins
[2]: https://jenkins.cilium.io/configfiles/
[3]: https://github.com/vaimr/pipeline-multibranch-defaults-plugin
[4]: https://github.com/cilium/packer-ubuntu-16.10
[5]: http://apt.llvm.org/
[6]: http://jenkins.cilium.io/scriptApproval/
