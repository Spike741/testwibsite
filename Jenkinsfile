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
                    // Clean Docker credentials to avoid conflicts (Windows syntax)
                    bat '''
                    if exist %USERPROFILE%\\.dockercfg del %USERPROFILE%\\.dockercfg
                    if exist %USERPROFILE%\\.docker\\config.json del %USERPROFILE%\\.docker\\config.json
                    '''

                    // Build Docker image
                    def dockerImage = docker.build("343218198881.dkr.ecr.ap-south-1.amazonaws.com/testwebsite:${env.BUILD_ID}")

                    // Push Docker image to ECR using Jenkins credentials
                    docker.withRegistry(
                        'https://343218198881.dkr.ecr.ap-south-1.amazonaws.com',
                        'aws-ecr-cred' // <-- Use your actual Jenkins credentials ID here
                    ) {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}
