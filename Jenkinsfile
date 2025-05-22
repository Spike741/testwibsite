pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REGISTRY = '343218198881.dkr.ecr.ap-south-1.amazonaws.com'
        ECR_REPOSITORY = 'testwebsite'
        IMAGE_TAG = "${env.BUILD_ID}"
        IMAGE_URI = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Spike741/testwibsite.git'
            }
        }

        stage('Authenticate Docker to ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-ecr-cred',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    bat """
                    aws configure set aws_access_key_id %AWS_ACCESS_KEY_ID%
                    aws configure set aws_secret_access_key %AWS_SECRET_ACCESS_KEY%
                    aws configure set default.region ${env.AWS_REGION}

                    aws ecr get-login-password --region ${env.AWS_REGION} | docker login --username AWS --password-stdin ${env.ECR_REGISTRY}
                    """
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def dockerImage = docker.build(env.IMAGE_URI)
                    dockerImage.push()
                }
            }
        }
    }
}
