pipeline {
    agent any
    
    triggers {
        githubPush()
    }
    
    environment {
        DOCKER_HUB_REPO = "sufyan12345/myapp"
        // Generate unique tag with build number
        BUILD_TAG = "build-${BUILD_NUMBER}"
        DOCKER_IMAGE = "${DOCKER_HUB_REPO}:${BUILD_TAG}"
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
                    // Build with unique tag
                    sh "docker build -t ${DOCKER_IMAGE} ."
                    // Also tag as latest
                    sh "docker tag ${DOCKER_IMAGE} ${DOCKER_HUB_REPO}:latest"
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        sh "docker push ${DOCKER_IMAGE}"
                        sh "docker push ${DOCKER_HUB_REPO}:latest"
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update deployment with new tag
                    sh "sed -i 's|image:.*|image: ${DOCKER_IMAGE}|g' k8s-deployment.yaml"
                    
                    // Apply the updated file
                    sh 'kubectl apply -f k8s-deployment.yaml'
                    
                    // Force restart
                    sh 'kubectl rollout restart deployment myapp'
                    sh 'kubectl rollout status deployment/myapp'
                }
            }
        }
    }
}