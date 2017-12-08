pipeline {
    agent {
        label 'vagrant'
    }
    options {
        timeout(time: 240, unit: 'MINUTES')
    }
    stages {
        stage ('Tests') {
            steps {
              echo 'Preparing VM'
              sh 'git clone https://github.com/scanf/bpf-ci-scripts workspace || true'
              sh 'git -C workspace pull origin master || true'
              sh 'mv workspace/Vagrantfile Vagrantfile'
              sh 'vagrant up' 
              echo 'Compile kernel'
              sh 'vagrant ssh -c "workspace/scripts/1_compile_kernel.sh"'
              echo 'Boot kernel'
              sh 'vagrant ssh -c "workspace/scripts/2_boot_kernel.sh"'
              echo 'Compile LLVM'
              sh 'vagrant ssh -c "workspace/scripts/3_compile_llvm.sh"'
              echo 'Run integration'
              sh 'vagrant ssh -c "workspace/scripts/4_run_integration.sh"'
              echo 'Run selftest'
              sh 'vagrant ssh -c "workspace/scripts/5_run_selftest.sh /src/kernel"'
            }
        }
    }
    post {
        always {
            sh 'vagrant destroy -f'
        }
    }
}
