pipeline {
  agent any

  environment{
    deploymentName = "devsecops"
    containerName = "devsecops-container"
    serviceName = "devsecops-svc"
    imageName  = "rnaeem/numeric-app:${GIT_COMMIT}"
    applicationURL = "http://devsecops-demo2.eastus.cloudapp.azure.com/"
    aplicationURI = "/increment/99"

  }

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
            parallel {
              stage ('Dependency Scan') {
                steps {
                  sh "mvn dependency-check:check"
                  } 
                }
              stage ('Trivy Scan') {
                steps {
                  sh "bash trivy-docker-image-scan.sh"
                  } 
                }
              stage ('OPA- Conftest') {
                steps {
                  sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest -p opa-docker-security.rego test Dockerfile'
                  } 
                }

              } 
      }
          
                  
      stage ('Docker build and Push Stage') {

            steps{
                withDockerRegistry([credentialsId: "dockerhub", url: ""]){

                  sh 'printenv'
                  sh 'sudo docker build -t rnaeem/numeric-app:""$GIT_COMMIT"" .'
                  sh 'docker push rnaeem/numeric-app:""$GIT_COMMIT""'

            }
        }

      }
      stage ('Vulnerability Scan - K8s') {

            steps{
                sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest -p opa-k8s-security.rego test k8s_deployment_service.yaml'

            }
        } 


      stage('Kubernetes Deployment - DEV') {
            parallel {
              stage ('Deployemnet') {
                steps {
                  withKubeConfig([credentialsId: 'kubeconfig']){

                  sh "bash k8s-deployment.sh"
                }
                  } 
                }
                //             stage ('Rollout Status') {
                //steps {
                  //withKubeConfig([credentialsId: 'kubeconfig']){

                  //sh "bash k8s-deployment-rollout-status.sh"
                //}
                //  } 
               // }

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