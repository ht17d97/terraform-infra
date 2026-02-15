pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['PLAN', 'APPLY', 'DESTROY'],
            description: 'Select Terraform Action'
        )
    }

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
    }

    stages {

        stage('Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-access-key']]) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            when {
                anyOf {
                    expression { params.ACTION == 'PLAN' }
                    expression { params.ACTION == 'APPLY' }
                    expression { params.ACTION == 'DESTROY' }
                }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-access-key']]) {
                    sh '''
                    if [ "$ACTION" = "DESTROY" ]; then
                        terraform plan -destroy -out=tfplan
                    else
                        terraform plan -out=tfplan
                    fi
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'APPLY' }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-access-key']]) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'DESTROY' }
            }
            steps {
                input message: "Are you sure you want to DESTROY infra?"
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-access-key']]) {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
