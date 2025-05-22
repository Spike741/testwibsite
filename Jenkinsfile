pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Spike741/testwibsite.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("hello-world:${env.BUILD_ID}")
                }
            }
        }

        stage('Push to AWS ECR') {
            steps {
                script {
                    docker.withRegistry('https://343218198881.dkr.ecr.ap-south-1.amazonaws.com', 'ecr-creds') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
