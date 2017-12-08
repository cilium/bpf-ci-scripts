pipeline {
    agent {
        label 'vagrant'
    }
    options {
        timeout(time: 240, unit: 'MINUTES')
        timestamps()
    }
    stages {
        stage ('Tests') {
            environment {
                MEMORY = '2048'
            }
            steps {
		    "Start VM": { sh 'vagrant up' },
                    "Compile kernel": { sh '1_compile_kernel.sh' },
                    "Boot kernel": { sh '2_boot_kernel.sh' },
                    "Compile LLVM": { sh '3_compile_llvm.sh' },
                    "Run integration": { sh '4_run_integration.sh' },
                    "Run selftest": { sh '5_run_selftest.sh .' },
            }
        }
    }
    post {
        always {
            sh 'vagrant destroy -f'
        }
    }
}

