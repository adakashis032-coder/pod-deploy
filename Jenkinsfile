pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "adakashis/pod-deploy:${env.BUILD_NUMBER}"
    }

    tools {
        maven 'Maven-3.8.1'
    }

    stages {
        stage('Checkout App') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/adakashis032-coder/pod-deploy.git',
                    credentialsId: '085c5197-0276-4de3-b806-90c1f60d8935'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean install'
                sh 'mvn test'
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

        stage('Deploy App') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh "kubectl --kubeconfig=$KUBECONFIG set image deployment/gcp-maven-ingress-kube gcp-maven-ingress-kube=$DOCKER_IMAGE"
                    sh "kubectl --kubeconfig=$KUBECONFIG rollout status deployment/gcp-maven-ingress-kube --timeout=60s"
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
