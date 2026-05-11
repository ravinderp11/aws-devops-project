pipeline {

    agent any

    stages {

        stage('Clone Code') {
            steps {
                git 'YOUR_GITHUB_REPO_URL'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-app:v1 ./app'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh 'docker stop devops-container || true'
                sh 'docker rm devops-container || true'
                sh 'docker run -d --name devops-container -p 80:80 devops-app:v1'
            }
        }
    }
}