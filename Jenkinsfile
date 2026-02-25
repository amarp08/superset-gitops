pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'amarp08'
        IMAGE_NAME = 'custom-superset'
        REGISTRY_CRED = 'docker-hub-credentials'
    }

    stages {
        stage('Debug Workspace') {
            steps {
                // This will print the folder structure so we can fix the path if it fails
                sh "ls -R"
            }
        }

        stage('Build Image') {
            steps {
                // If the folder is k8s-spec, keep this. 
                // If it is k8s_spec, change the dash (-) to an underscore (_)
                sh "docker build -f dockerfile.dockerfile -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
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

        stage('Deploy to SysUser VM') {
            steps {
                // This uses the kubeconfig on the SysAdmin VM to talk to SysUser VM (192.168.30.134)
                sh "kubectl rollout restart deployment superset -n superset"
            }
        }
    }
}