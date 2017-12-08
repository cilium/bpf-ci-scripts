pipeline {
    agent {
        label 'vagrant'
    }
    options {
        timeout(time: 240, unit: 'MINUTES')
        timestamps()
    }
    stages {
        stage ('Setup VM') {
            environment { MEMORY = '2048' }
            steps {
              sh 'git clone https://github.com/scanf/bpf-ci-scripts workspace',
              sh 'vagrant up' 
            }
        }
        stage ('Compile kernel') {
            environment { MEMORY = '2048' }
            steps {
              vagrant ssh -c "workspace/scripts/1_compile_kernel.sh"
            }
        }
        stage ('Boot kernel') {
            environment { MEMORY = '2048' }
            steps {
              vagrant ssh -c "workspace/scripts/2_boot_kernel.sh"
            }
        }
        stage ('Compile LLVM') {
            environment { MEMORY = '2048' }
            steps {
                vagrant ssh -c "workspace/scripts/3_compile_llvm.sh"
            }
        }
        stage ('Run integration') {
            environment { MEMORY = '2048' }
            steps {
                vagrant ssh -c "workspace/scripts/4_run_integration.sh"
            }
        }
        stage ('Run integration') {
            environment { MEMORY = '2048' }
            steps {
                vagrant ssh -c "workspace/scripts/5_run_selftest.sh /src/kernel"
            }
        }
    }
    post {
        always {
            sh 'vagrant destroy -f'
        }
    }
}

