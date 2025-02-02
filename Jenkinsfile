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
                    docker.image('node:18').inside {
                        sh '''
                        cd frontend
                        npm install
                        npm run build --prod
                        '''
                    }
                }
            }
        }
        
        stage('Build Backend') {
            steps {
                script {
                    docker.image('node:16').inside {
                        sh '''
                        cd backend
                        npm install
                        '''
                    }
                }
            }
        }
        
        stage('Build Docker Images') {
            steps {
                script {
                    sh 'docker build -t frontend-app -f frontend/Dockerfile .'
                    sh 'docker build -t backend-app -f backend/Dockerfile .'
                }
            }
        }
        
        stage('Run Application') {
            steps {
                script {
                    sh 'docker-compose up -d'
                }
            }
        }
    }
}
