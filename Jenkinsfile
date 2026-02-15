pipeline {
    agent any

    tools {
        terraform 'terraform'
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
                    sh '''
                    export AWS_DEFAULT_REGION=us-east-1
                    terraform init
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-access-key']]) {
                    sh '''
                    export AWS_DEFAULT_REGION=us-east-1
                    terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}
