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
        stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t spring-boot-demo .'
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker push spring-boot-demo'
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh 'kubectl apply -f k8s/deployment.yaml'
                    sh 'kubectl apply -f k8s/service.yaml'
                }
            }
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

