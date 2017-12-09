#!groovy
pipeline {
    agent {
      label 'vagrant'
    }
    options {
      timeout(time: 240, unit: 'MINUTES')
    }
    stages {
      stage ('Tests') {
        environment {
          VM_MEMORY = '4096'
          VM_CPUS = '4'
        }
        steps {
          echo 'Step: Preparing VM'
            sh 'git clone https://github.com/scanf/bpf-ci-scripts workspace || true'
            sh 'git -C workspace checkout . || true'
            sh 'git -C workspace pull origin master || true'
            sh 'cp workspace/Vagrantfile Vagrantfile'
            sh 'vagrant plugin install vagrant-reload'
            sh 'vagrant up'
            echo 'Step: Compile LLVM'
            sh 'vagrant ssh -c "workspace/workspace/scripts/3_compile_llvm.sh"'
            echo 'Step: Run integration'
            sh 'vagrant ssh -c "workspace/workspace/scripts/4_run_integration.sh"'
            echo 'Step: Run selftest'
            sh 'vagrant ssh -c "workspace/workspace/scripts/5_run_selftest.sh ~/workspace"'
        }
      }
    }
    post {
      always {
        sh 'vagrant destroy -f'
      }
    }
}
