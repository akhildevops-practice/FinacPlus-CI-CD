pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'akhilprabhu2005/spring-boot-demo:latest' // Your Docker image name
        K8S_NAMESPACE = 'default'  // Change to your Kubernetes namespace if necessary
    }
    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository...'
                git 'https://github.com/akhildevops-practice/FinacPlus-CI-CD.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh '''
                        docker build -t ${DOCKER_IMAGE} .
                    '''
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    echo 'Pushing Docker image to Docker Hub...'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh '''
                            docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                            docker push ${DOCKER_IMAGE}
                        '''
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo 'Deploying to Kubernetes...'
                    sh '''
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                script {
                    echo 'Verifying the deployment...'
                    sh '''
                        kubectl get pods -n ${K8S_NAMESPACE}
                        kubectl get services -n ${K8S_NAMESPACE}
                    '''
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





