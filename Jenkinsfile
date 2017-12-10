#!groovy
pipeline {
    agent {
      label 'vagrant'
    }
    options {
      timeout(time: 240, unit: 'MINUTES')
    }
    stages {
      stage ('Preparing VM (compile and boot kernel)') {
        environment {
          VM_MEMORY = '4096'
          VM_CPUS = '4'
        }
        steps {
            sh 'git clone https://github.com/scanf/bpf-ci-scripts workspace || true'
            sh 'git -C workspace checkout . || true'
            sh 'git -C workspace pull origin master || true'
            sh 'cp workspace/Vagrantfile Vagrantfile'
            sh 'vagrant plugin install vagrant-reload'
            sh 'vagrant plugin install vagrant-scp'
	    sh 'mkdir -pv ARTIFACTS'
            sh 'vagrant up'
        }
      }
      stage ('Install LLVM development branch') {
        steps {
          sh 'vagrant ssh -c "workspace/workspace/scripts/3_get_llvm_snapshot.sh"'
        }
      }
      stage ('Run Cilium selected tests') {
        steps {
            sh 'vagrant ssh -c "workspace/workspace/scripts/4_run_integration.sh"'
        }
      }
      stage ('Run selftest') {
        steps {
            sh 'vagrant ssh -c "workspace/workspace/scripts/5_run_selftest.sh ~/workspace"'
        }
      }
    }
    post {
      always {
	sh 'vagrant scp :workspace/tools/testing/selftests/bpf/ ARTIFACTS/selftest-bpf || true'
	sh 'vagrant scp :workspace/.config ARTIFACTS/KernelConfig.txt || true'
	sh 'vagrant destroy -f'
	archiveArtifacts artifacts: 'ARTIFACTS/**/*.*', fingerprint: true
      }
      failure {
	emailext (
	    to: 'alexander@alemayhu.com',
	    subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
	    body: "Details at ${env.BUILD_URL}consoleFull",
	    attachLog: true,
	    )
      }
      success {
	mail to: 'alexander@alemayhu.com',
	     subject: "Completed Pipeline: ${currentBuild.fullDisplayName}",
	     body: "Details at ${env.BUILD_URL}"
      }
    }
}
