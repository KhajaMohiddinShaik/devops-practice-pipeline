pipeline {
    agent any

    environment {
        IMAGE_NAME = "khajamohiddin11/practice-repo:v1"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/KhajaMohiddinShaik/devops-practice-pipeline.git'
            }
        }

        stage('Code Info') {
    	    steps {
       		sh 'git branch'
       		sh 'git log --oneline -n 3'
     	    }
	}
	stage('Setup Python') {
            steps {
                sh '''
                python3 -m venv venv
                . venv/bin/activate

                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }
	stage('Formatting') {
		steps {
			sh '''
				.venv/bin/python -m black . --extend-exclude "venv|.venv|__pycache__|build|dist"
				'''
		}
	}
	stage('Lint') {
		steps {
			sh './venv/bin/python -m flake8 .'
		}
	}

        stage('Test') {
            steps {
                sh '''
                . venv/bin/activate

                pytest
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                    docker push $IMAGE_NAME
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully 🚀'
        }

        failure {
            echo 'Pipeline failed ❌'
        }
    }
}
