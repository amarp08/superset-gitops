pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = 'cooding4startup'
        IMAGE_NAME = 'custom-superset'
        REGISTRY_CRED = 'docker-hub-credentials' // The ID you set in Jenkins
    }
    stages {
        stage('Build Image') {
            steps {
                // Notice the -f to specify your custom dockerfile name
                sh "docker build -f k8s-spec/dockerfile.dockerfile -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:${env.BUILD_ID} ."
            }
        }
        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CRED}", passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo \$PASS | docker login -u \$USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${env.BUILD_ID}"
                }
            }
        }
    }
}