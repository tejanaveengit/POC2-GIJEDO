pipeline {
    agent any

    environment {
        IMAGE_NAME = "dockerdemmo/simple-docker-app7"
        TAG = "latest"
    }

    tools {
        maven 'Maven'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/tejanaveengit/POC2-GIJEDO.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Dependency Check') {
    steps {
        withCredentials([string(
            credentialsId: 'nvd-api-key',
            variable: 'NVD_API_KEY'
        )]) {
            sh '''
              mvn org.owasp:dependency-check-maven:check \
              -Dnvd.api.key=$NVD_API_KEY
            '''
        }
    }
}
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image $IMAGE_NAME:$TAG'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-creds',
                        usernameVariable: 'USER',
                        passwordVariable: 'PASS'
                    )
                ]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $IMAGE_NAME:$TAG'
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker stop poc-container || true
                    docker rm poc-container || true
                    docker run -d -p 8081:8080 --name poc-container $IMAGE_NAME:$TAG
                '''
            }
        }
    }
} 
