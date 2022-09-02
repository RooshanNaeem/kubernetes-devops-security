pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //Adding comment 
            }
          }
      stage('Unit Test') {
            steps {
              sh "mvn test" 
            }
            post {
              always {

                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }


            }
        }
      stage ('Docker build and Push Stage') {
            steps{
                withDockerRegistry([credentialsId: "dockerhub", url: ""]){

                  sh 'printenv'
                  sh 'docker build -t rnaeem/devsecops-numeric: ""$GIT_COMMIT"" .'
                  sh 'docker push rnaeem/devsecops-numeric:""$GIT_COMMIT""'

            }
        }

      }    
    }
}