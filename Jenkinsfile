pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['PLAN', 'APPLY', 'DESTROY'],
            description: 'Select Terraform Action'
        )
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

        stage('Terraform PLAN') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-access-key']]) {
                    sh '''
                    export AWS_DEFAULT_REGION=us-east-1

                    if [ "$ACTION" = "DESTROY" ]; then
                        terraform plan -destroy -out=tfplan
                    else
                        terraform plan -out=tfplan
                    fi
                    '''
                }
            }
        }

        stage('Terraform Execute') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-access-key']]) {
                    sh '''
                    export AWS_DEFAULT_REGION=us-east-1

                    if [ "$ACTION" = "DESTROY" ]; then
                        terraform destroy -auto-approve
                    elif
                        terraform plan
                    else
                        terraform apply -auto-approve tfplan
                    fi
                    '''
                }
            }
        }
    }
}
