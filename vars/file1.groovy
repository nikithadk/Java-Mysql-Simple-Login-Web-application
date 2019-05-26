def call(Map params) {

    pipeline {
   // try{
        node('master') {
stage('Clone') {
    checkout([$class: 'GitSCM', branches: [[name:'*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: params.url]]])
}


stage('SonarQube analysis') {
    withSonarQubeEnv('sonar') {
      sh 'mvn sonar:sonar -Dsonar.host.url='+params.sonarURL
   }
}

stage('SonarQube quality gate check')
{
def qualitygate=waitForQualityGate()
if(qualitygate.status!='OK'){
error "pipeline aborted due to quality gate failure : ${qualitygate.status}"
}
}

stage('Build & Upload') {

rtMavenDeployer (
    id: 'deployer-unique-id',
    serverId: 'server1',
    releaseRepo: 'release/${BUILD_NUMBER}',
    snapshotRepo: "snapshot/${BUILD_NUMBER}"
)

rtMavenRun (
    tool: 'maven',
type: 'maven',
    pom: 'pom.xml',
    //goals: 'clean install org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar',
goals: params.mvngoal,
    opts: '-Xms1024m -Xmx4096m',
    deployerId: 'deployer-unique-id',
)
}

stage('Artifact Download') {
rtDownload (
    serverId: "server1",
    spec:
        """{
          "files": [
            {
              "pattern": "snapshot/${BUILD_NUMBER}/com/javawebtutor/LoginWebApp/1.0-SNAPSHOT/LoginWebApp-1.0*.war",
              "target": "/var/lib/jenkins/workspace/${JOB_NAME}/"
            }
         ]
        }"""
)
}

stage ('Application Deployment'){
  sh 'scp /var/lib/jenkins/workspace/${JOB_NAME}/${BUILD_NUMBER}/com/javawebtutor/LoginWebApp/1.0-SNAPSHOT/LoginWebApp-1.0*.war ubuntu@'+params.serverURL+':/home/ubuntu/'
  sh 'ssh ubuntu@'+params.serverURL+' \'sudo mv /home/ubuntu/LoginWebApp-1.0*.war /var/lib/tomcat8/webapps/\''
}
}
//}
//catch (err) { 
//         mail body:"${err}. Check result at ${BUILD_URL}", subject: "Build Failed ${JOB_NAME} - Build # ${BUILD_NUMBER}", to: params.email
//          currentBuild.result = 'FAILURE'
//      }
}
}
return this

