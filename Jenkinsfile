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
            post {
              always {

                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }


            }
        }
      stage('SonarQube Analysis - SAST') {
            steps{
            sh "mvn sonar:sonar -Dsonar.projectKey=numeric-app -Dsonar.host.url=http://devsecops-demo2.eastus.cloudapp.azure.com:9000 -Dsonar.login=f152cfea314af5df449327976f133c3e32e53a99"
        }  
      }

      stage('Mutation Test - PIT') {
            steps {
              sh "mvn org.pitest:pitest-maven:mutationCoverage" 
            }
            post {
              always {

                pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
              }


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
}