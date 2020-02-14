pipeline {
  agent any
  environment {
    DOCKER_REGISTRY = ""
    GOOGLE_APPLICATION_CREDENTIALS = "/home/ubuntu/gcp-creds.json"
  }
  stages {
    stage('Create Cloud Image') {
      steps {
        sh 'virtualenv --python="$(command -v python3.6)" --no-site-packages venv'
        sh "venv/bin/python -m pip install ansible"
        sh ". venv/bin/activate && make build-vm"
      }
    }
  }
}
