stage('Build') {
  steps {
    sh 'mvn clean package'
  }
}

stage('Docker Build') {
  steps {
    sh 'docker build -t simple-docker-app .'
  }
}

stage('Run Container') {
  steps {
    sh 'docker run --rm simple-docker-app'
  }
}
