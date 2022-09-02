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
              sh 'printenv'
              sh 'docker build -t rnaeem/numeric-app:""$GIT_COMMT"" .'
              sh 'docker push rnaeem/numeric-app:""$GIT_COMMIT""'

            }


      }    
    }
}