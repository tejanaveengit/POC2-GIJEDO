pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        APP_NAME = "simple-docker-app"
        IMAGE_TAG = "latest"
        JAR_NAME = "simple-docker-app-0.0.1-SNAPSHOT.jar"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build JAR') {
            steps {
                sh '''
                    mvn clean package
                    ls -l target
                '''
            }
        }

        stage('Verify JAR') {
            steps {
                sh '''
                    if [ ! -f target/${JAR_NAME} ]; then
                      echo "❌ JAR not found!"
                      exit 1
                    fi
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${APP_NAME}:${IMAGE_TAG} .
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker run --rm -d \
                    -p 8080:8080 \
                    --name ${APP_NAME} \
                    ${APP_NAME}:${IMAGE_TAG}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Build and deployment successful"
        }

        failure {
            echo "❌ Pipeline failed"
        }

        always {
            sh '''
                docker ps -a | grep ${APP_NAME} && docker stop ${APP_NAME} || true
            '''
        }
    }
}
