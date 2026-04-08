pipeline {
    agent any

    environment {
        IMAGE_NAME = "simple-docker-app"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
         stage('build') {
            steps {
               sh 'mvn clean package'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(

                    credentialsId: 'docker-creds',

                    usernameVariable: 'USER',

                    passwordVariable: 'PASS'
                )]) {

                    sh 'echo $PASS | docker login -u $USER --password-stdin'

                    sh 'docker push $IMAGE_NAME:latest'

                }

            }

        }
 
        stage('Deploy') {

            steps {

                sh '''

                docker run -d -p 8081:8080 --name docker-container $IMAGE_NAME:latest

                '''

            }

        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
