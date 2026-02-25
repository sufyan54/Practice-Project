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
                // Verify CSS exists
                sh 'ls -la style.css || echo "⚠️ CSS file missing!"'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // FORCE rebuild with NO CACHE
                    sh 'docker build --no-cache -t ${DOCKER_IMAGE} .'
                    
                    // Verify CSS is in the image
                    sh 'docker run --rm ${DOCKER_IMAGE} ls -la /usr/share/nginx/html/style.css'
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        sh 'docker push ${DOCKER_IMAGE}'
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Force Kubernetes to use new image
                    sh 'kubectl set image deployment/myapp myapp=${DOCKER_IMAGE} --record'
                    sh 'kubectl rollout restart deployment myapp'
                    sh 'kubectl rollout status deployment/myapp --timeout=60s'
                    
                    // Show running pods with new image
                    sh '''
                        echo "✅ Running pods:"
                        kubectl get pods
                        
                        echo "\\n✅ Checking CSS in new pod:"
                        POD=$(kubectl get pods -l app=myapp -o jsonpath='{.items[0].metadata.name}')
                        kubectl exec $POD -- ls -la /usr/share/nginx/html/style.css
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ CI/CD Pipeline completed successfully! CSS deployed!'
        }
        failure {
            echo '❌ CI/CD Pipeline failed!'
        }
    }
}