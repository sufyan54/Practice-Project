pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        IMAGE_NAME = "sufyan12345/myapp"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = "dockerhub-credentials"
        K8S_DEPLOYMENT = "myapp"
        K8S_CONTAINER  = "myapp"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🔨 Building Docker Image: ${IMAGE_NAME}:${IMAGE_TAG}"
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    echo "📤 Pushing Image to DockerHub..."
                    docker.withRegistry('', DOCKER_CREDENTIALS) {
                        docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "🚀 Updating Kubernetes Deployment..."

                    sh """
                        kubectl set image deployment/${K8S_DEPLOYMENT} \
                        ${K8S_CONTAINER}=${IMAGE_NAME}:${IMAGE_TAG}

                        kubectl rollout status deployment/${K8S_DEPLOYMENT}

                        echo "📊 Current Pods:"
                        kubectl get pods -o wide
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Pipeline completed successfully!"
        }
        failure {
            echo "❌ CI/CD Pipeline failed!"
        }
    }
}