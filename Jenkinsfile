pipeline {
   agent { label 'agent' }
   environment {
        dockerhub=credentials('Docker_Hub') 
         }
   stages {
        stage('lint') {
            steps {
                script {
                  sh "npm  install"
                  sh "npm run format"
                //   sh "npm run lint"
                }
            }
            }
        stage('build') {
            steps {
                script {
                  sh "npm run build"
                }
            }
            post {
                success {
                    slackSend (channel: '#general', color: '#00FF00', message: "BUILD STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")

                }
                failure {
slackSend (channel: '#general', color: '#FF0000', message: "BUILD STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                }
            }
        }
        stage('Unit test') {
            steps {
                sh 'npm test'
            }
            post {
                success {
                    slackSend (channel: '#general', color: '#00FF00', message: "TEST STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                }
                failure {
slackSend (channel: '#general', color: '#FF0000', message: "TEST STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                }
            }
        }
        // stage('security scan') { 
           
            
        //     steps {
        //         sh 'npm install'
        //         sh 'npm audit fix --audit-level=critical --force'
        //         sh 'npm audit --audit-level=critical'
        //     }
//             post {
//                 success {
//                     slackSend (channel: '#general', color: '#00FF00', message: "SCAN STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
// slackSend (channel: '#general', color: '#FF0000', message: "SCAN STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
//         }


        stage('build image') {
            steps {
                script {
                     if (env.BRANCH_NAME == 'blue') {
                        sh """
                        docker login -u $dockerhub_USR -p $dockerhub_PSW
                        docker build -t mohab5897/reactapp-blue:$BUILD_NUMBER .
                        docker push mohab5897/reactapp-blue:$BUILD_NUMBER
                        docker rmi mohab5897/reactapp-blue:$BUILD_NUMBER
                        docker image prune -f
                        echo ${BUILD_NUMBER} > Deployment/build-blue
                        echo ${BRANCH_NAME} > Deployment/build-branch
                        """
                    } else if ( env.BRANCH_NAME == 'green') {
                    sh """
                        docker login -u $dockerhub_USR -p $dockerhub_PSW
                        docker build -t mohab5897/reactapp-green:$BUILD_NUMBER .
                        docker push mohab5897/reactapp-green:$BUILD_NUMBER
                        docker rmi mohab5897/reactapp-green:$BUILD_NUMBER
                        docker image prune -f
                        echo ${BUILD_NUMBER} > Deployment/build-green
                        echo ${BRANCH_NAME} > Deployment/build-branch
                        """
                       
              
                      }
                } 

            }
             post {
                success {
                    slackSend (channel: '#general', color: '#00FF00', message: "IMAGE CREATION STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                }
                failure {
slackSend (channel: '#general', color: '#FF0000', message: "IMAGE CREATION STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                }
            }
        }
                stage('deploy') {
            steps {
                script {
                     if (env.BRANCH_NAME == 'blue') {
                          withCredentials([file(credentialsId: 'my', variable: 'my')]){

                    sh """
                            gcloud auth activate-service-account serviceaccount@mohab-372519.iam.gserviceaccount.com --key-file="$my" --project=mohab-372519
                            gcloud container clusters get-credentials app-cluster --region europe-west3 --project mohab-372519
                            export BUILD_NUMBER=\$(cat Deployment/build-blue)
                            mv Deployment/blue/blue.yaml Deployment/blue/blue
                        cat Deployment/blue/blue | envsubst > Deployment/blue/blue.yaml
                        rm -f Deployment/blue/blue
                        cat Deployment/blue/blue.yaml 
                            export BRANCH_NAME=\$(cat Deployment/build-branch)
                            mv Deployment/blue/service.yaml Deployment/blue/service
                        cat Deployment/blue/service | envsubst > Deployment/blue/service.yaml
                        rm -f Deployment/blue/service
                        cat Deployment/blue/service.yaml 
                        kubectl apply -f Deployment/blue
                        """
                         } 
                    } else if ( env.BRANCH_NAME == 'green') {
                     withCredentials([file(credentialsId: 'my', variable: 'my')]){

                    sh """
                            gcloud auth activate-service-account serviceaccount@mohab-372519.iam.gserviceaccount.com --key-file="$my" --project=mohab-372519
                            gcloud container clusters get-credentials app-cluster --region europe-west3-b --project mohab-372519
                            export BUILD_NUMBER=\$(cat Deployment/build-green)
                            mv Deployment/green/green.yaml Deployment/green/green
                        cat Deployment/green/green | envsubst > Deployment/green/green.yaml
                        rm -f Deployment/green/green
                        cat Deployment/green/green.yaml 
                            export BRANCH_NAME=\$(cat Deployment/build-branch)
                            mv Deployment/green/service.yaml Deployment/green/service
                        cat Deployment/green/service | envsubst > Deployment/green/service.yaml
                        rm -f Deployment/green/service
                        cat Deployment/green/service.yaml 
                        kubectl apply -f Deployment/green/
                        """
                         } 
                       
              
                   }
                } 

            }
            post {
                    success {
                    slackSend (channel: '#general', color: '#00FF00', message: "DEPLOYMENT STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                    }
                    failure {
slackSend (channel: '#general', color: '#FF0000', message: "DEPLOYMENT STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                    }
            }
        }

            
        }
}