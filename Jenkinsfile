pipeline {
    agent any
    
    environment {
        MYSQL_ROOT_PASSWORD = 'rootpassword'
        DB_NAME = 'appdb'
        DB_USER = 'root'
        DB_PASSWORD = 'rootpassword'
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
        
        stage('Build Docker Images') {
            steps {
                script {
                    sh 'docker build -t frontend-app -f angular-app/frontend/Dockerfile .'
                    sh 'docker build -t backend-app -f angular-app/backend/Dockerfile .'
                }
            }
        }
        
        stage('Run Application') {
            steps {
                script {
                    sh 'docker-compose -f angular-app/docker-compose.yml up -d'
                }
            }
        }
    }
}