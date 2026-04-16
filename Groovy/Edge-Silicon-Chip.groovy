pipeline {
    agent any

    environment {
        APP_NAME = "Edge-AI-APP"
        VERSION = "1.0.${env.BUILD_NUMBER}"
        REGISTRY = "dockerhub.io/edge-ai"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/usuario/edge-ai-app.git'
            }
        }

        stage('Build') {
            steps {
                sh './gradlew clean build'
            }
        }

        stage('Unit Tests') {
            steps {
                sh './gradlew test'
            }
        }

        stage('Package Binary') {
            steps {
                sh "mkdir -p artifacts && cp build/libs/${APP_NAME}.jar artifacts/${APP_NAME}-${VERSION}.jar"
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${REGISTRY}/${APP_NAME}:${VERSION} ."
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin dockerhub.io"
                    sh "docker push ${REGISTRY}/${APP_NAME}:${VERSION}"
                }
            }
        }

        stage('Release Tag') {
            steps {
                sh "git tag v${VERSION}"
                sh "git push origin v${VERSION}"
            }
        }

        stage('Deploy') {
            steps {
                sh "./scripts/deploy.sh ${VERSION}"
            }
        }
    }

    post {
        success {
            echo "✅ Release ${VERSION} of ${APP_NAME} completed successfully!"
        }
        failure {
            echo "❌ Build failed. Check logs."
        }
    }
}
