pipeline {
    agent any

    environment {
        // Change 'amarp08' to your actual Docker Hub username
        DOCKER_HUB_USER = 'amarp08'
        IMAGE_NAME = 'custom-superset'
        // This ID must match the one you created in Jenkins Credentials
        REGISTRY_CRED = 'docker-hub-credentials'
    }

    stages {
        stage('Build Image') {
            steps {
                // Points to your specific dockerfile location
                sh "docker build -f k8s-spec/dockerfile.dockerfile -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CRED}", passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo \$PASS | docker login -u \$USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy/Update') {
            steps {
                // This tells your cluster to refresh the deployment with the new image
                sh "kubectl rollout restart deployment superset -n superset"
            }
        }
    }
}