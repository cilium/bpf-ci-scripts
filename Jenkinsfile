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
                    "Compile kernel": { vagrant ssh -c "scripts/1_compile_kernel.sh" },
                    "Boot kernel": { vagrant ssh -c "scripts/2_boot_kernel.sh" },
                    "Compile LLVM": { vagrant ssh -c "scripts/3_compile_llvm.sh" },
                    "Run integration": { vagrant ssh -c "scripts/4_run_integration.sh" },
                    "Run selftest": { vagrant ssh -c "scripts/5_run_selftest.sh /src/kernel" },
            }
        }
    }
    post {
        always {
            sh 'vagrant destroy -f'
        }
    }
}

