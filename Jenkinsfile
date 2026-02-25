pipeline {
    agent any
    
    triggers {
        githubPush()
    }
    
    environment {
        DOCKER_IMAGE = "sufyan12345/myapp:latest"
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
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Use the correct filename
                    sh 'kubectl apply -f k8s-deployment.yaml'  // Make sure this matches your filename
                    sh 'kubectl rollout status deployment/myapp'
                    
                    // Show deployment status
                    sh '''
                        echo "📊 Deployment Status:"
                        kubectl get pods
                        kubectl get svc
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ CI/CD Pipeline completed successfully!'
        }
        failure {
            echo '❌ CI/CD Pipeline failed!'
        }
    }
}