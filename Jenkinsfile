pipeline {
    agent { label "Docker"}
    stages {
        stage("Docker build") {
            agent { label "Docker"}
                steps {
                    sh 'docker image build -t spc:1.0 . '
                }
        }
    }
}