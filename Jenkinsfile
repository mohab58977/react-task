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
        // stage('build') {
        //     steps {
        //         script {
        //           sh "npm run build"
        //         }
        //     }
//             post {
//                 success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "BUILD STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")

//                 }
//                 failure {
// slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "BUILD STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
        // }
        // stage('Unit test') {
        //     steps {
        //         sh 'npm test'
        //     }
//             post {
//                 success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "TEST STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
// slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "TEST STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
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
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "TEST STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
// slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "TEST STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
        // }


//         stage('Build Image') {
//             steps {
//                 script {
//                     if (env.BRANCH_NAME == 'blue') {
//                         sh 'docker build -t blue:1.0 .'
//                 } else if (env.BRANCH_NAME == 'green') {
//                         sh 'docker build -t stage:1.0 .'
//                 } else {
//                         sh 'docker build -t test:1.0 .'
//                     }
//                 }
//             }
//             post {
//                 success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "BUILD IMAGE STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
//                 }slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "BUILD IMAGE STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")

//             }
//         }
//         stage('Push Image') {
//             environment {
//                 DOCKER_HUB = credentials('DockerHub')
//             }
//             steps {
//                 script {
//                     if (env.BRANCH_NAME == 'main') {
//                         sh 'echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USR --password-stdin'
//                         sh 'docker tag prod:1.0 mohamedalaaelsafy/prod:1.0'
//                         sh 'docker push mohamedalaaelsafy/prod:1.0'
//                         sh 'docker rmi mohamedalaaelsafy/prod:1.0'
//                         sh 'docker image prune -f'
//                         sh 'docker logout'
//                 } else if (env.BRANCH_NAME == 'stage') {
//                         sh 'echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USR --password-stdin'
//                         sh 'docker tag stage:1.0 mohamedalaaelsafy/stage:1.0'
//                         sh 'docker push mohamedalaaelsafy/stage:1.0'
//                         sh 'docker rmi mohamedalaaelsafy/stage:1.0'
//                         sh 'docker image prune -f'
//                         sh 'docker logout'
//                 } else {
//                         sh 'echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USR --password-stdin'
//                         sh 'docker tag test:1.0 mohamedalaaelsafy/test:1.0'
//                         sh 'docker push mohamedalaaelsafy/test:1.0'
//                         sh 'docker rmi mohamedalaaelsafy/test:1.0'
//                         sh 'docker image prune -f'
//                         sh 'docker logout'
//                     }
//                 }
//             }
//             post {
//                 success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "PUSH IMAGE STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
// slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "PUSH IMAGE STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
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
                            gcloud container clusters get-credentials app-cluster --region europe-west3 --project mohab-372519
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

            post {
                    success {
                    slackSend (channel: 'general', color: '#00FF00', message: "DEPLOYMENT STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                    }
                    failure {
slackSend (channel: 'general', color: '#FF0000', message: "DEPLOYMENT STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                    }
            }
        }
        stage('Done') {
            steps {
                echo 'DONEDeployment.'
            }
            post {
                success {
                    slackSend (channel: 'general', color: '#00FF00', message: "CONGRATULATIONS ALL STAGES SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                }
                failure {
 slackSend (channel: 'general', color: '#FF0000', message: "SORRY BUILD FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
                }
            }
        }
}
