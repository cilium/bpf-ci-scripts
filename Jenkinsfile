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
		    "Start VM": {
                      sh 'git clone https://github.com/scanf/bpf-ci-scripts workspace',
                      sh 'vagrant up' 
                    },
                    "Compile kernel": { vagrant ssh -c "workspace/scripts/1_compile_kernel.sh" },
                    "Boot kernel": { vagrant ssh -c "workspace/scripts/2_boot_kernel.sh" },
                    "Compile LLVM": { vagrant ssh -c "workspace/scripts/3_compile_llvm.sh" },
                    "Run integration": { vagrant ssh -c "workspace/scripts/4_run_integration.sh" },
                    "Run selftest": { vagrant ssh -c "workspace/scripts/5_run_selftest.sh /src/kernel" },
            }
        }
    }
    post {
        always {
            sh 'vagrant destroy -f'
        }
    }
}

