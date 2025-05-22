pipeline {
    agent any

    environment {
        AWS_REGION       = 'ap-south-1'  // Your AWS region
        AWS_ACCOUNT_ID   = '343218198881' // Your AWS Account ID
        ECR_REPOSITORY   = 'testwebsite' // Your ECR repository name
        ECR_REGISTRY     = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_TAG        = "${env.BUILD_ID}"
        IMAGE_URI        = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
        CREDENTIALS_ID   = 'aws-ecr-creds'  // Jenkins AWS Credentials ID (must match Jenkins credentials)
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Spike741/testwibsite.git'
            }
        }

        stage('Configure AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${env.CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    script {
                        // Configure AWS CLI with injected credentials
                        bat "aws configure set aws_access_key_id %AWS_ACCESS_KEY_ID%"
                        bat "aws configure set aws_secret_access_key %AWS_SECRET_ACCESS_KEY%"
                        bat "aws configure set default.region ${env.AWS_REGION}"

                        // Optional: verify AWS identity
                        bat 'aws sts get-caller-identity'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image tagged with ECR URI and build ID
                    def dockerImage = docker.build("${env.IMAGE_URI}")
                }
            }
        }

        stage('Login to ECR and Push Image') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${env.CREDENTIALS_ID}",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    script {
                        // Login to ECR using AWS CLI
                        bat """
                        aws ecr get-login-password --region ${env.AWS_REGION} | docker login --username AWS --password-stdin ${env.ECR_REGISTRY}
                        """

                        // Push the Docker image to ECR
                        def dockerImage = docker.image("${env.IMAGE_URI}")
                        dockerImage.push()
                    }
                }
            }
        }

        // Optional: Kubernetes deployment stages can be added here if needed
        /*
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-credentials-id', variable: 'KUBECONFIG')]) {
                    sh 'kubectl apply -f k8s-manifests/'
                }
            }
        }
        */
    }

    post {
        success {
            echo 'Pipeline completed successfully! Docker image pushed to ECR.'
        }
        failure {
            echo 'Pipeline failed! Check the logs for errors.'
        }
    }
}
