pipeline {

    agent any

    environment {

        AWS_REGION = 'us-east-1'

        ECR_REPOSITORY = 'aws-devops-app'

        APP_HOST = '100.54.220.199'
    }

    stages {

        stage('Git Checkout') {

            steps {

                checkout scm

                echo 'Source code downloaded successfully'
            }
        }

        stage('Maven Build') {

            steps {

                sh 'chmod +x scripts/build.sh'

                sh './scripts/build.sh'
            }
        }

        stage('Docker Build and ECR Push') {

            steps {

                script {

                    env.IMAGE_TAG = env.GIT_COMMIT.take(7)

                    env.AWS_ACCOUNT_ID = sh(
                        script: "aws sts get-caller-identity --query Account --output text",
                        returnStdout: true
                    ).trim()

                    env.IMAGE_URI = "${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.ECR_REPOSITORY}:${env.IMAGE_TAG}"
                }

                sh 'chmod +x scripts/docker-build-push.sh'

                sh './scripts/docker-build-push.sh'
            }
        }

        stage('Deploy to AWS EC2') {

            steps {

                sshagent(credentials: ['app-server-ssh-key']) {

                    sh '''
                        chmod +x scripts/deploy.sh

                        ./scripts/deploy.sh \
                        "$APP_HOST" \
                        "$IMAGE_URI"
                    '''
                }
            }
        }

        stage('Application Verification') {

            steps {

                sh '''
                    curl --fail --retry 10 --retry-delay 5 \
                    "http://$APP_HOST:8080/health"
                '''
            }
        }
    }

    post {

        success {

            echo 'AWS DevOps deployment completed successfully!'
        }

        failure {

            echo 'AWS DevOps deployment failed. Check Jenkins console output.'
        }
    }
}