pipeline {
    agent { label 'OPENJDK' }
    triggers { pollSCM('* * * * *') }
    stages {
        stage('git') {
            steps {
                git branch: 'main', url: 'https://github.com/krishna5683akp/spring-petclinic.git'              
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
                    tool: 'MAVEN_TOOL', // Tool name from Jenkins configuration
                    pom: 'pom.xml',
                    goals: 'package',
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
        stage ('SoanrQube Analysis') {
            steps { 
                withSonarQubeEnv('SONARQUBE') {
                    sh 'mvn clean package sonar:sonar'
                }
            }
        }
        stage('docker image') {
            steps {
                sh """docker image build -t spc:1.0 .
                    docker image tag spc:1.0 fortestingmyself.jfrog.io/myrepo/spc:1.0
                    docker push fortestingmyself.jfrog.io/myrepo/spc:1.0"""
            }
        }
    }
    post {
        success {
            junit '**/surefire-reports/*.xml'
        }
        // failure {
        //     echo 'job failed'
        //     mail subject: 'build failed for jenkins',
        //          body: 'build failed for jenkins',
        //          to: 'madasukrishnaprasad5683@gmail.com'           
        // }

    }
}
