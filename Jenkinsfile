pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //Adding comment 
            }
          }
      stage('Unit Test- JUnit and Jacoco') {
            steps {
              sh "mvn test" 
            }

        }

      stage('Mutation Test - PIT') {
            steps {
              sh "mvn org.pitest:pitest-maven:mutationCoverage" 
            }

        }
      stage('SonarQube Analysis - SAST') {
            steps{
              withSonarQubeEnv('SonarQube'){
            sh "mvn sonar:sonar -Dsonar.projectKey=numeric-app -Dsonar.host.url=http://devsecops-demo2.eastus.cloudapp.azure.com:9000"
          }
            
      }
    }    
      stage('Vulnerability Scan') {
            steps {
              
                  sh "mvn dependency-check:check"

              } 
      }
          
                  
      stage ('Docker build and Push Stage') {

            steps{
                withDockerRegistry([credentialsId: "dockerhub", url: ""]){

                  sh 'printenv'
                  sh 'docker build -t rnaeem/numeric-app:""$GIT_COMMIT"" .'
                  sh 'docker push rnaeem/numeric-app:""$GIT_COMMIT""'

            }
        }

      }   
      stage ('Kubernetes Deployment - DEV') {
            steps{
                withKubeConfig([credentialsId: 'kubeconfig']){

                  sh "sed -i 's#replace#rnaeem/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
                  sh "kubectl apply -f k8s_deployment_service.yaml"
            }
        }

      }  
    }
  post {
    always {
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
                pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
                dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'

    }
  //  success {

  //  }
  //  failure {


 //   }

  }
}