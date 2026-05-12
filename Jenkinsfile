pipeline {
    agent any

    environment {
        IMAGE_NAME = "khajamohiddin11/practice-repo:${BUILD_NUMBER}"
	EC2_IP = "ec2-13-201-57-124.ap-south-1.compute.amazonaws.com"
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
				./venv/bin/python -m black . --extend-exclude "venv|.venv|__pycache__|build|dist"
				'''
		}
	}
	stage('Parallel Checks') {
	parallel {
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

	stage('Deploy to EC2') {
		steps {
			withCredentials([
				usernamePassword(
				credentialsId: 'dockerhub-creds',
				usernameVariable: 'DOCKER_USER',
				passwordVariable: 'DOCKER_PASS')
			]) {

			sshagent (credentials: ['ec2-ssh-key']) {
				sh '''
				ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
				echo "${DOCKER _PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
				docker pull ${IMAGE_NAME}
				docker stop fastapi-app || true
				docker rm fastapi-app || true
				docker run -d --name fastapi-app -p 8000:8000 ${IMAGE_NAME}
				'
				'''
				}

			}
			}
		}
	}

    post {
        success {
            echo 'Pipeline completed successfully 🚀'
	    echo 'Suucessfully deployed to EC2'
        }

        failure {
            echo 'Pipeline failed ❌'
        }
	always {
		sh 'docker image prune -f'	
	}
    }
}
