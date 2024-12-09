pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'akhilprabhu2005/spring-boot-demo:latest'  // Your Docker image name
        K8S_NAMESPACE = 'default'  // Change to your Kubernetes namespace if necessary
    }
    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository
                git 'https://github.com/akhildevops-practice/FinacPlus-CI-CD.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply Kubernetes deployment and service files
                    sh 'kubectl apply -f k8s/deployment.yaml'
                    sh 'kubectl apply -f k8s/service.yaml'
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                script {
                    // Verify the deployment
                    sh 'kubectl get pods'
                    sh 'kubectl get services'
                }
            }
        }
    }
    post {
        success {
            echo 'Deployment to Kubernetes was successful!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}


