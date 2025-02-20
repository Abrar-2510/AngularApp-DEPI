pipeline {
    agent any

    environment {
        MYSQL_ROOT_PASSWORD = 'rootpassword'
        DB_NAME = 'appdb'
        DB_USER = 'root'
        DB_PASSWORD = 'rootpassword'
        FRONTEND_IMAGE = 'abrar2510/angularapp'
        FRONTEND_TAG = 'frontend-latest'
        BACKEND_IMAGE = 'abrar2510/angularapp'
        BACKEND_TAG = 'backend-latest'
        KUBERNETES_NAMESPACE = 'angularapp'
        SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/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"
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build Frontend') {
            steps {
                script {
                    sh '''
                    cd angular-app/frontend
                    npm install
                    npm run build --prod
                    '''
                }
            }
        }

        stage('Build Backend') {
            steps {
                script {
                    sh '''
                    cd angular-app/backend
                    npm install
                    '''
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    }
                }
            }
        }

        stage('Build and Push Docker Images') {
            steps {
                script {
                    sh '''
                    docker build -t $FRONTEND_IMAGE:$FRONTEND_TAG -f angular-app/frontend/Dockerfile .
                    docker push $FRONTEND_IMAGE:$FRONTEND_TAG

                    docker build -t $BACKEND_IMAGE:$BACKEND_TAG -f angular-app/backend/Dockerfile .
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
                        --set frontend.service.type=NodePort \
                        --set frontend.service.port=80 \
                        --set frontend.service.targetPort=80 \
                        --set frontend.service.nodePort=30080 \
                        --set backend.image.repository=$BACKEND_IMAGE \
                        --set backend.image.tag=$BACKEND_TAG \
                        --set backend.service.type=NodePort \
                        --set backend.service.port=3000 \
                        --set backend.service.targetPort=3000 \
                        --set backend.service.nodePort=30301 \
                        --set mysql.rootPassword=$MYSQL_ROOT_PASSWORD \
                        --set mysql.database=$DB_NAME \
                        --set mysql.user=$DB_USER \
                        --set mysql.password=$DB_PASSWORD \
                        --set mysql.service.type=ClusterIP \
                        --set mysql.service.port=3306 \
                        --set autoscaling.enabled=false \
                        --set autoscaling.minReplicas=1 \
                        --set autoscaling.maxReplicas=3 \
                        --set autoscaling.targetCPUUtilizationPercentage=80
                    '''
                }
            }
        }
    }

    post {
        success {
            script {
                sh """
                curl -X POST -H 'Content-type: application/json' --data '{"text":"Jenkins Pipeline: Deployment successful! ✅"}' $SLACK_WEBHOOK_URL
                """
            }
        }
        failure {
            script {
                sh """
                curl -X POST -H 'Content-type: application/json' --data '{"text":"Jenkins Pipeline: Deployment failed! ❌"}' $SLACK_WEBHOOK_URL
                """
            }
        }
    }
}