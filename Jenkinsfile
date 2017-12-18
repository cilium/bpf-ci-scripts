#!groovy
pipeline {
    agent {
      label 'vagrant'
    }
    options {
      timeout(time: 70, unit: 'MINUTES')
    }
    stages {
      stage ('Preparing VM (compile and boot kernel)') {
        environment {
          VM_MEMORY = '4096'
          VM_CPUS = '4'
        }
        steps {
            sh 'vagrant ssh -c "workspace/workspace/scripts/0_setup_vm.sh"'
        }
      }
      stage ('Install LLVM development branch') {
        steps {
          sh 'vagrant ssh -c "workspace/workspace/scripts/3_get_llvm_snapshot.sh"'
        }
      }
      stage ('Run Cilium selected tests') {
        steps {
            sh 'vagrant ssh -c "workspace/workspace/scripts/4_run_integration.sh" || true'
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
	sh './workspace/scripts/6_artifacts.sh'
	sh './workspace/scripts/6_cleanup.sh'
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
