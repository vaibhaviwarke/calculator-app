pipeline {
    options {
        buildDiscarder(logRotator(numToKeepStr: '10')) 
  }
  agent {
    node{
        label 'my_local_server'
    }
  }
  environment {
        CONTAINER_NAME = "flask-sample-app" 
    }
  stages {  
    stage('Git Checkout') { 
      steps {
        checkout scm
      }
    }
    stage('SonarQube Analysis') {
      withSonarQubeEnv('SonarQubeServer') { 
        steps {
          def sonarRunner = tool name: 'SonarQubeScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
            sh """
              ${sonarRunner}/bin/sonar-scanner \
              -Dsonar.projectKey=your_project_key \
              -Dsonar.sources=.
            """
        }
      }
    }
    stage('Build Docker Image') { 
      steps {
        script {
          sh 'docker image build -t $CONTAINER_NAME:latest .'
        }
      }
    }
    stage('Unit Testing') { 
      steps {
        script {
          sh 'docker stop $CONTAINER_NAME || true'
          sh 'docker rm $CONTAINER_NAME || true'
          sh 'docker run -dp 5000:5000 --name $CONTAINER_NAME $CONTAINER_NAME /bin/bash -c "python test_calculator.py"'
        }
      }
    }
    stage('Run Docker Image') { 
      steps {
        script {
          sh 'docker stop $CONTAINER_NAME || true'
          sh 'docker rm $CONTAINER_NAME || true'
          sh 'docker run -dp 5000:5000 --name $CONTAINER_NAME $CONTAINER_NAME'
        }
      }
    }
  }
}
