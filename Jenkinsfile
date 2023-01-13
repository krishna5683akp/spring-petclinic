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
                    releaseRepo: "fortetsingrepo-libs-release-local",
                    snapshotRepo: "fortetsingrepo-libs-snapshot-local"
                )
            }
        }
        stage ('Exec Maven') {
            steps {
                rtMavenRun (
                    tool: 'MAVEN_TOOL', // Tool name from Jenkins configuration
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: "MAVEN_DEPLOYER"
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
        // stage('download url'){
        //     steps {
        //         rtDownload (
        //             serverId: 'JFROG_ID',
        //             spec: '''{
        //                 "files": [
        //                     {
        //                     "pattern": "https://fortestingmyself.jfrog.io/artifactory/fortetsingrepo-libs-release-local/org/springframework/samples/spring-petclinic/2.7.3/",
        //                     "target": "spring-petclinic-2.7.3.jar/"
        //                     }
        //                 ]
        //             }''',
        //         ) 
        //     }
        // }     
        stage('docker image') {
            steps {  
                withCredentials([usernamePassword(credentialsId: 'JFROG_ID', passwordVariable: 'jfrogpass', usernameVariable: 'jfroguser')]) {
                sh "curl -u ${jfroguser}:${jfrogpass} https://fortestingmyself.jfrog.io/artifactory/fortetsingrepo-libs-release-local/org/springframework/samples/spring-petclinic/2.7.3/spring-petclinic-2.7.3.jar"
                sh """docker image build -t spc:1.0 .
                    docker image tag spc:1.0 fortestingmyself.jfrog.io/myrepo/spc:${BUILD_NUMBER}
                    docker push fortestingmyself.jfrog.io/myrepo/spc:${BUILD_NUMBER}"""}
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
