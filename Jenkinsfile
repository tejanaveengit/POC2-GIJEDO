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

              stage('OWASP Scan') {
                steps {
                withCredentials([string(credentialsId: 'nvd-api-key', variable: 'NVD_KEY')]) {
                    dependencyCheck(
                        odcInstallation: 'Dependency-Check',
                        additionalArguments: '--scan . --out ./dc-report --format XML --format HTML --noupdate'
                    )
                }
         
                dependencyCheckPublisher(
                    pattern: 'dc-report/dependency-check-report.xml'
                )
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

            stage('Trivy Scan') {
                steps {
                    script {
                        sh '''
                        mkdir -p trivy-cache
                        # Step 1: Download DB (ignore failure)
                        trivy image --download-db-only --cache-dir trivy-cache || true
                        # Step 2: Run scan (never fail pipeline)
                        trivy image \
                        --cache-dir trivy-cache \
                        --skip-db-update \
                        --scanners vuln \
                        --exit-code 0 \
                        $IMAGE_NAME:$TAG || true
                        '''
                    }
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
