pipeline {
    agent any

    stages {
        stage('Fetch') {
            steps {
                git branch: 'white', url: 'https://github.com/hyfung/flask-awsebs-terraform-example'
            }
        }
        
        stage('Pack')
        {
            steps {
                sh 'zip app_${BUILD_NUMBER}.zip application.py requirements.txt virt/'
            }
        }
        
        stage('Deploy') {
            steps {
                withAWS(credentials: 'jerry', region: 'us-west-2') {
                    sh 'terraform init'
                    // sh 'export TF_VAR_build_number=${BUILD_NUMBER}'
                    // sh 'terraform plan'
                    // sh 'terraform apply --auto-approve'
                    sh 'terraform apply -var="build_number=${BUILD_NUMBER}" --auto-approve'
                }
            }
        }
    }
}
