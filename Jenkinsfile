pipeline {
    agent { label "Docker"}
    stages {
        stage("Docker build") {
            steps {
                sh 'docker image build -t spc:1.0 .'
            }
        }
    }
}