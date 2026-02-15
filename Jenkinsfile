pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'git-access',
                    url: 'https://github.com/ht17d97/terraform-infra.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-access-key']]) {

                    sh '''
                    export AWS_DEFAULT_REGION=us-east-1
                    terraform init
                    terraform validate
                    terraform plan
                    terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}
