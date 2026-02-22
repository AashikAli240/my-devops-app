pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        DOCKER_IMAGE = "aashikali240/my-devops-app"
        KUBE_CONFIG = credentials('kubeconfig-cred')
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/AashikAli240/my-devops-app.git'
            }
        }

        stage('Install Node Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            when { expression { fileExists('test') } }
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                docker push ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-cred', variable: 'KUBECONFIG_FILE')]) {
                    sh """
                    export KUBECONFIG=$KUBECONFIG_FILE
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml || true
                    kubectl apply -f ingress.yaml
                    kubectl apply -f hpa.yaml
                    """
                }
            }
        }

        stage('Apply Terraform (Optional)') {
            when { expression { fileExists('main.tf') } }
            steps {
                sh """
                terraform init
                terraform apply -auto-approve
                """
            }
        }

        stage('Run Ansible (Optional)') {
            when { expression { fileExists('ansible') } }
            steps {
                sh """
                ansible-playbook ansible/playbook.yaml
                """
            }
        }
    }

    post {
        success {
            echo "Deployment Successful!"
        }
        failure {
            echo "Pipeline Failed!"
        }
    }
}
