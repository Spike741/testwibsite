pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Spike741/testwibsite.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Clean Docker credentials to avoid conflicts
                    sh 'rm -f ~/.dockercfg ~/.docker/config.json || true'

                    def dockerImage = docker.build("343218198881.dkr.ecr.ap-south-1.amazonaws.com/testwebsite:${env.BUILD_ID}")

                    docker.withRegistry('https://343218198881.dkr.ecr.ap-south-1.amazonaws.com', 'ecr:ap-south-1:aws-ecr-creds') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
