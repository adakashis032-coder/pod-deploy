pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "adakashis/pod-deploy:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout App') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/adakashis032-coder/pod-deploy.git',
                    credentialsId: '085c5197-0276-4de3-b806-90c1f60d8935'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds',
                                                 usernameVariable: 'USER',
                                                 passwordVariable: 'PASS')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker build -t $DOCKER_IMAGE ."
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }


        stage('Checkout Manifests') {
            steps {
                git branch: 'main', url: 'https://github.com/adakashis032-coder/pod-deploy.git'
            }
        }

        stage('Deploy Nginx & Kibana') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh "kubectl --kubeconfig=$KUBECONFIG apply -f nginx-deploy.yaml -n monitoring"
                    sh "kubectl --kubeconfig=$KUBECONFIG apply -f kibana-deploy.yaml -n monitoring"
                }
            }
        }
    }

    post {
        success {
            echo '✅ All deployments succeeded!'
        }
        failure {
            echo '❌ Something failed. Check logs.'
        }
    }
}
