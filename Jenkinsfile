pipeline {
    options {
        buildDiscarder(logRotator(numToKeepStr: '3')) 
  }
  agent {
    node{
      label 'my_local_server'
    }
  }
  environment {
        CONTAINER_NAME = "flask-sample-app" 
        VERSION = "0.0.4"
        NEXUS_URL = "43.205.146.251:9081"
        NEXUS_REPOSITORY = "calculator-app"
        NEXUS_CREDENTIALS = "nexus-cred"
    }
  stages {
    stage('Git Checkout') {
      steps {
        checkout scm
      }
    }
    stage('SonarQube analysis') {
      steps {
        script {
          // requires SonarQube Scanner 2.8+
          scannerHome = tool 'SonarScanner'
        }
        withSonarQubeEnv('SonarScanner') {
          sh "${scannerHome}/bin/sonar-scanner"
        }
      }
    }
    stage('Checkmarx Scan') {
      steps {
        script {
          sh 'docker run -t -v /var/lib/jenkins/workspace/calculator-app/src:/path checkmarx/kics:latest scan -p /path -o "/path/"'
        }
      }
    } 
    stage('Unit Testing') {
      steps {
        script {
          sh 'python src/test_calculator.py'
          // sh 'docker stop $CONTAINER_NAME || true'
          // sh 'docker rm $CONTAINER_NAME || true'
          // sh 'docker run -dp 5000:5000 --name $CONTAINER_NAME $CONTAINER_NAME /bin/bash -c "python test/test_calculator.py"'
        }
      }
    }
    stage('Artifact Manager') {
      steps {
        script {
          sh 'python3 setup.py bdist_wheel'
        }
      }
    }
    stage('Upload Artifacts to nexus') {
      steps {
        nexusArtifactUploader(
          nexusVersion: 'nexus3',
          protocol: 'http',
          nexusUrl: "$NEXUS_URL",
          groupId: 'calculator-app',
          version: "$VERSION",
          repository: "$NEXUS_REPOSITORY",
          credentialsId: "$NEXUS_CREDENTIALS",
          artifacts: [
              [
                artifactId: 'calculator-app',
                classifier: '',
                file: 'dist/calculator_app-' + "$VERSION" +'-py3-none-any.whl',
                type: 'whl'
              ]
          ]
        )
      }
    }
    stage('Build Docker Image') {
      steps {
        script {
          sh "docker image build -t $CONTAINER_NAME:$VERSION ."
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
