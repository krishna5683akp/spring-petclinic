pipeline {
    agent { label 'OPENJDK' }
    stages {
        stage('git') {
            steps {
                mail subject: 'build started for jenkins', 
                    body: 'build started for jenkins',
                    to: 'madasukrishnaprasad5683@gmail.com',                
                git branch: 'main', url: 'https://github.com/krishna5683akp/js-e2e-express-server.git'
            }
        }
        // stage('installing dependencies') {
        //     steps {
        //         sh """sudo apt  install nodejs -y
        //             sudo apt-get install npm -y
        //             npm install"""
        //     }
        // }
        stage ('Artifactory configuration') {
            steps {
                // rtServer (
                //     id: "JFROG_ID",
                //     url: "https://fortestingmyself.jfrog.io/",
                //     credentialsId: CREDENTIALS
                // )

                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "JFROG_ID",
                    releaseRepo: "myrepo-libs-release-local",
                    snapshotRepo: "myrepo-libs-snapshot-local"
                )
            }
        }
        stage ('Exec Maven') {
            steps {
                rtMavenRun (
                    tool: MAVEN_TOOL, // Tool name from Jenkins configuration
                    pom: 'pom.xml',
                    goals: 'mvn package',
                    deployerId: "MAVEN_DEPLOYER",
                    resolverId: "MAVEN_RESOLVER"
                )
            }
        }

        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "JFROG_ID"
                )
            }
        }
        post {
            always {
                echo 'Job is completed' 
                mail subject: 'build started for jenkins',
                    body: 'build started for jenkins',
                    to: 'madasukrishnaprasad5683@gmail.com', 
            }
            failure {
                echo 'Job failed'
                mail subject: 'build started for jenkins',
                    body: 'build started for jenkins',
                    to: 'madasukrishnaprasad5683@gmail.com', 
            }
        }
        stage('docker image') {
            steps {
                sh """docker image build -t js:1.0 .
                    docker image tag js:1.0 madasu/js:1.0
                    docker push madasu/js:1.0"""
            }
        }
    }
}
