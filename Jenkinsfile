pipeline {
  agent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket
    }
  }

  environment {
    SONAR_URL = "http://your-sonarqube-server-url:9000"
    DOCKER_IMAGE = "akhilprabhu2005/spring-boot-app:${BUILD_NUMBER}"
    GIT_REPO_NAME = "FinacPlus-CI-CD"
    GIT_USER_NAME = "akhilprabhu20"
  }

  stages {
    stage('Checkout') {
      steps {
        echo 'Checking out the code'
        git branch: 'main', url: 'https://github.com/akhildevops-practice/FinacPlus-CI-CD.git'
        sh 'ls -l'  // Verify files in the workspace
      }
    }

    stage('Static Code Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          echo 'Running SonarQube static code analysis'
          sh '''
            cd spring-boot-app
            mvn sonar:sonar \
              -Dsonar.login=$SONAR_AUTH_TOKEN \
              -Dsonar.host.url=${SONAR_URL}
          '''
        }
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        echo 'Building and pushing Docker image'
        script {
          sh '''
            cd spring-boot-app
            docker build -t ${DOCKER_IMAGE} .
          '''
          docker.withRegistry('https://index.docker.io/v1/', 'docker-hub') {
            sh '''
              docker push ${DOCKER_IMAGE}
            '''
          }
        }
      }
    }

    stage('Update Deployment File') {
      steps {
        withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
          echo 'Updating Kubernetes deployment file with new image tag'
          sh '''
            git config user.email "akhilprabhu20@gmail.com"
            git config user.name "akhilprabhu20"
            sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" kubernetes/deployment.yml
            git add kubernetes/deployment.yml
            git commit -m "Update deployment image to version ${BUILD_NUMBER}"
            git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        echo 'Deploying to Kubernetes'
        script {
          sh '''
            kubectl apply -f kubernetes/deployment.yml
            kubectl apply -f kubernetes/service.yml
          '''
        }
      }
    }

    stage('Verify Deployment') {
      steps {
        echo 'Verifying deployment'
        script {
          sh '''
            kubectl get pods
            kubectl get services
          '''
        }
      }
    }
  }

  post {
    success {
      echo 'Pipeline executed successfully!'
    }
    failure {
      echo 'Pipeline execution failed.'
    }
  }
}





