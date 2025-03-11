pipeline {
    agent any

    environment {
        MYSQL_ROOT_PASSWORD = 'rootpassword'
        DB_NAME = 'appdb'
        DB_USER = 'root'
        DB_PASSWORD = 'rootpassword'
        AWS_ACCOUNT_ID = '438465127898'
        AWS_REGION = 'us-east-1'
        FRONTEND_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/angular-frontend"
        FRONTEND_TAG = 'latest'
        BACKEND_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/angular-backend"
        BACKEND_TAG = 'latest'
        KUBERNETES_NAMESPACE = 'angularapp'
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('AWS ECR Login') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'aws-ecr-token', variable: 'ECR_PASSWORD')]) {
                        sh '''
                        echo "$ECR_PASSWORD" | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                        '''
                    }
                }
            }
        }

        stage('Build and Push Docker Images') {
            steps {
                script {
                    sh '''
                    docker build -t $FRONTEND_IMAGE:$FRONTEND_TAG -f frontend/Dockerfile frontend
                    docker push $FRONTEND_IMAGE:$FRONTEND_TAG

                    docker build -t $BACKEND_IMAGE:$BACKEND_TAG -f backend/Dockerfile backend
                    docker push $BACKEND_IMAGE:$BACKEND_TAG
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes using Helm') {
            steps {
                script {
                    sh '''
                    helm upgrade --install angularapp angularapp-chart --namespace $KUBERNETES_NAMESPACE --create-namespace \
                        --set frontend.image.repository=$FRONTEND_IMAGE \
                        --set frontend.image.tag=$FRONTEND_TAG \
                        --set backend.image.repository=$BACKEND_IMAGE \
                        --set backend.image.tag=$BACKEND_TAG \
                        --wait
                    '''
                }
            }
        }
    }

    post {
        success {
            script {
                withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_WEBHOOK_URL')]) {
                    sh '''
                    curl -X POST -H 'Content-type: application/json' --data '{"text":"✅ Jenkins Pipeline: Deployment successful!"}' $SLACK_WEBHOOK_URL
                    '''
                }
            }
        }
        failure {
            script {
                withCredentials([string(credentialsId: 'slack-webhook', variable: 'SLACK_WEBHOOK_URL')]) {
                    sh '''
                    curl -X POST -H 'Content-type: application/json' --data '{"text":"❌ Jenkins Pipeline: Deployment failed!"}' $SLACK_WEBHOOK_URL
                    '''
                }
            }
        }
    }
}
