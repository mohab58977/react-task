pipeline {
   agent { label 'agent' }
   environment {
        dockerhub=credentials('Docker_Hub') 
         }
   stages {
        // stage('lint') {
        //     steps {
        //         script {
        //           sh "npm  install"
        //           sh "npm run format"
        //         //   sh "npm run lint"
        //         }
        //     }
        //     }
//         stage('build') {
//             steps {
//                 script {
//                   sh "npm run build"
//                 }
//             }
//             post {
//                 success {
//                     slackSend (channel: '#general', color: '#00FF00', message: "BUILD STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")

//                 }
//                 failure {
// slackSend (channel: '#general', color: '#FF0000', message: "BUILD STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
//         }
        // stage('Unit test') {
        //     steps {
        //         sh 'npm test'
        //     }
//             post {
//                 success {
//                     slackSend (channel: '#general', color: '#00FF00', message: "TEST STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
// slackSend (channel: '#general', color: '#FF0000', message: "TEST STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
        // }
        // stage('security scan') { 
           
            
        //     steps {
        //         sh 'npm install'
                // sh 'npm audit fix --audit-level=critical --force'
                // sh 'npm audit --audit-level=critical'
            // }
//             post {
//                 success {
//                     slackSend (channel: '#general', color: '#00FF00', message: "TEST STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
// slackSend (channel: '#general', color: '#FF0000', message: "TEST STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
        // }


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
                        cat ../build-blue
                        echo ${BRANCH_NAME} > Deployment/build-branch
                        cat Deployment/build-branch
                        """
                    } else if ( env.BRANCH_NAME == 'green') {
                    sh """
                        docker login -u $dockerhub_USR -p $dockerhub_PSW
                        docker build -t mohab5897/reactapp-green:$BUILD_NUMBER .
                        docker push mohab5897/reactapp-green:$BUILD_NUMBER
                        docker rmi mohab5897/reactapp-green:$BUILD_NUMBER
                        docker image prune -f
                        echo ${BUILD_NUMBER} > Deployment/build-green
                        cat Deployment/build-green
                        echo ${BRANCH_NAME} > Deployment/build-branch
                        cat Deployment/build-branch
                        """
                       
              
                      }
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
                            mv Deployment/blue.yaml Deployment/blue
                        cat Deployment/blue | envsubst > Deployment/blue.yaml
                        rm -f Deployment/blue
                        cat Deployment/blue.yaml 
                            export BRANCH_NAME=\$(cat Deployment/build-branch)
                            mv Deployment/service.yaml Deployment/service
                        cat Deployment/service | envsubst > Deployment/service.yaml
                        rm -f Deployment/service
                        cat Deployment/service.yaml 
                        kubectl apply -f Deployment/
                        """
                         } 
                    } else if ( env.BRANCH_NAME == 'green') {
                     withCredentials([file(credentialsId: 'my', variable: 'my')]){

                    sh """
                            gcloud auth activate-service-account serviceaccount@mohab-372519.iam.gserviceaccount.com --key-file="$my" --project=mohab-372519
                            gcloud container clusters get-credentials app-cluster --region europe-west3-b --project mohab-372519
                            export BUILD_NUMBER=\$(cat Deployment/build-green)
                            mv Deployment/green.yaml Deployment/green
                        cat Deployment/green | envsubst > Deployment/green.yaml
                        rm -f Deployment/green
                        cat Deployment/green.yaml 
                            export BRANCH_NAME=\$(cat Deployment/build-branch)
                            mv Deployment/service.yaml Deployment/service
                        cat Deployment/service | envsubst > Deployment/service.yaml
                        rm -f Deployment/service
                        cat Deployment/service.yaml 
                        kubectl apply -f Deployment/
                        """
                         } 
                       
              
                   }
                } 

            }
        }

//             post {
//                     success {
//                     slackSend (channel: '#general', color: '#00FF00', message: "DEPLOYMENT STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                     }
//                     failure {
// slackSend (channel: '#general', color: '#FF0000', message: "DEPLOYMENT STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                     }
//             }
        }
//         stage('Done') {
//             steps {
//                 echo 'DONEDeployment.'
//             }
//             post {
//                 success {
//                     slackSend (channel: '#general', color: '#00FF00', message: "CONGRATULATIONS ALL STAGES SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
//  slackSend (channel: '#general', color: '#FF0000', message: "SORRY BUILD FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
//         }
}
