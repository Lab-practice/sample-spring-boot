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
            agent {
                docker {
                    image 'jshimko/kube-tools-aws:3.8.1'
                    args '-u root --privileged'
                }
            }

            steps{
                echo 'Deploying to kubernetes'

                withAWS(credentials:'aws-credentials') {
                    sh 'aws eks update-kubeconfig --name sre-primer'
                    sh 'chmod +x deployment-status.sh && ./deployment-status.sh'
                    sh "kubectl set image deployment sample-spring-boot -n sidi_gassama springboot-sample=$ENV_DOCKER_USR/$DOCKERIMAGE:$BUILD_ID"
                }
            }
        }

}
}
