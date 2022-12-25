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
                  sh "npm run lint"
                }
            }
            }
        stage('build') {
            steps {
                script {
                  sh "npm install"
                  sh "npm run build"
                }
            }
//             post {
//                 success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "BUILD STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")

//                 }
//                 failure {
// slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "BUILD STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
        }
        stage('Unit test') {
            steps {
                sh 'npm install'
                sh 'npm test'
            }
//             post {
//                 success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "TEST STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
// slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "TEST STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
        }
        stage('security scan') { 
           
            
            steps {
                sh 'npm install'
                sh 'npm audit fix --audit-level=critical --force'
                sh 'npm audit --audit-level=critical'
            }
//             post {
//                 success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "TEST STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
// slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "TEST STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
        }


//         stage('Build Image') {
//             steps {
//                 script {
//                     if (env.BRANCH_NAME == 'main') {
//                         sh 'docker build -t prod:1.0 .'
//                 } else if (env.BRANCH_NAME == 'stage') {
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
        stage('build image and deploy') {
            steps {
                steps {
                script {
                    if (env.BRANCH_NAME == 'master') {
                        sh """
                        docker login -u $dockerhub_USR -p $dockerhub_PSW
                        docker build -t mohab5897/app:$BUILD_NUMBER .
                        docker push mohab5897/app:$BUILD_NUMBER
                        docker rmi mohab5897/app:$BUILD_NUMBER
                        docker image prune -f
                        echo ${BUILD_NUMBER} > ../build
                        """
                    } else if ( env.BRANCH_NAME == 'dev') {
                       
                withCredentials([file(credentialsId: 'my', variable: 'my')]){

                    sh """
                            gcloud auth activate-service-account  my-service-account@project-for-mohab.iam.gserviceaccount.com --key-file="$my" --project=project-for-mohab
                            gcloud container clusters get-credentials app-cluster --region europe-west3 --project project-for-mohab
                            export BUILD_NUMBER=\$(cat ../build)
                             mv Deployment/deploy.yaml Deployment/deploy
                        cat Deployment/deploy | envsubst > Deployment/deploy.yaml
                        rm -f Deployment/deploy
                        cat Deployment/deploy.yaml 
                        kubectl apply -f Deployment/
                        """
                         } 
                      }
                } 

            }
        }

//             post {
//                     success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "DEPLOYMENT STAGE SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                     }
//                     failure {
// slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "DEPLOYMENT STAGE FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                     }
//             }
        }
//         stage('Done') {
//             steps {
//                 echo 'DONE...'
//             }
//             post {
//                 success {
//                     slackSend (channel: 'jenkins-pipeline', color: '#00FF00', message: "CONGRATULATIONS ALL STAGES SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//                 failure {
//  slackSend (channel: 'jenkins-pipeline', color: '#FF0000', message: "SORRY BUILD FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'")
//                 }
//             }
//         }
    }
}
