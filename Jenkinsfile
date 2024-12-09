pipeline {
  agent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // Mount Docker socket to access the host's Docker daemon
    }
  }
  stages {
    stage('Checkout') {
      steps {
        echo 'Checking out the code'
        git branch: 'main', url: 'https://github.com/akhildevops-practice/FinacPlus-CI-CD.git'
      }
    }

  stage('Checkout') {
    steps {
      echo 'Checking out the code'
      git branch: 'main', url: 'https://github.com/akhilprabhu20/your-repo-name.git'
      sh 'ls -l'  // List files in the workspace to check the directory structure
     }
   }


    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "http://your-sonarqube-server-url:9000"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          echo 'Running SonarQube static code analysis'
          sh 'cd spring-boot-app && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }

    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "akhilprabhu2005/spring-boot-app:${BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = credentials('docker-hub')
      }
      steps {
        echo 'Building Docker image'
        script {
          sh 'cd spring-boot-app && docker build -t ${DOCKER_IMAGE} .'
          
          // Push image to Docker Hub
          def dockerImage = docker.image("${DOCKER_IMAGE}")
          docker.withRegistry('https://index.docker.io/v1/', "docker-hub") {
            echo 'Pushing Docker image to registry'
            dockerImage.push()
          }
        }
      }
    }

    stage('Update Deployment File') {
      environment {
        GIT_REPO_NAME = "FinacPlus-CI-CD"
        GIT_USER_NAME = "akhilprabhu20"
      }
      steps {
        withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
          echo 'Updating Kubernetes deployment file with new image tag'
          sh '''
            git config user.email "akhilprabhu20@gmail.com"
            git config user.name "akhilprabhu20"
            BUILD_NUMBER=${BUILD_NUMBER}
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
          // Apply Kubernetes manifests (e.g., deployment and service)
          sh 'kubectl apply -f kubernetes/deployment.yml'
          sh 'kubectl apply -f kubernetes/service.yml'
        }
      }
    }
  }
}



