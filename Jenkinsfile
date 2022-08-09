pipeline {
    agent none
        environment {
        ENV_DOCKER = credentials('dockerhub')
        SONAR_TOKEN = credentials('sonar')
        DOCKERIMAGE = "sgassama5/lab-practice"
        EKS_CLUSTER_NAME = "demo-cluster"
    }
    stages {
        stage('build') {
            agent {
                docker { image 'openjdk:11-jdk' }
            }
            steps {
                sh 'chmod +x gradlew && ./gradlew build jacocoTestReport'
            }
        }
        stage('sonarqube') {
        agent {
            docker { image 'sonarsource/sonar-scanner-cli:latest' } }
            steps {
                sh 'sonar-scanner'
            }
        }
        stage('docker build') {
            agent any
            steps {
                sh 'echo docker build'

                script {
                    image = docker.build("$ENV_DOCKER_USR/$DOCKERIMAGE")
                }
            }
        }
         stage('docker push') {
            agent any
            steps {
                sh 'echo docker push!'

                script {
                    docker.withRegistry('', 'dockerhub') {
                        image.push("$BUILD_ID")
                        image.push('latest')
                    }
                }
            }
        }

        stage('Deploy App') {
            steps {
                sh 'echo deploy to kubernetes'               
            }
    }
}
}
