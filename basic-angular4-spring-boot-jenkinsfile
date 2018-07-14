pipeline {
    agent {
        node {
            label 'master'
        }
    }
    
    environment {
        JENKINS_NODE_COOKIE = 'dontkill'
    }
    
    stages {
        stage('Preparation') { // for display purposes
            steps {
              // clean the workspace
              cleanWs()
            }
        }

       stage('Download') {
           steps {
              // Download code from a GitHub repository
              git branch: 'staging', url: 'https://github.com/revalution/janus-webapp.git'
           }
        }

        stage('NPM Install') {
            steps {
                // go into client-side directory
                dir('client-side') {
                    // install node modules
                    sh 'npm install'
                }
            }
        }

        stage('NPM Build') {
            steps {
                dir('client-side') {
                    // build Angular app
                    sh 'npm run build-uat'
                }
            }
        }

        stage('MVN Build') {
            steps {
                dir('spring-boot-server') {
                    // Run the maven build
                    sh "mvn -Dmaven.test.failure.ignore clean package"
                }
            }
        }
        
        stage('Destroy Old Server') {
            steps {
                script {
                    try {
                        // kill any running instances
                        sh "fuser -k 8088/tcp"
                    } catch (all) {
                        // if it fails that should mean a server wasn't already running
                    }
                }
            }
        }

        stage('Deploy') {
            /*
            * deploying a docker container example
            agent {
                docker {
                    image 'openjdk/8-jre'
                    label 'janus-server'
                    args ''
                }
            }
            */
            
            steps {
                
                dir('spring-boot-server') {
                    dir ('target') {
                        // run the Janus server
                        sh "nohup java -jar janus-server.jar &"
                    }
                }
            }
        }

    }
    
    post {
        always {
            sh "echo 'i always run'"
            
            /* SLACK message example
            
            slackSend channel: '#some-channel',
                color: 'good',
                message: "The Janus server has attempted a build"
                
            */
        }
        
        success {
            sh "echo 'i only run on success'"
        }
        
        unstable {
            sh "echo 'i run when the build is unstable (testing?)'"
        }
        
        failure {
            sh "echo 'i run when things failed'"
        }
        
        changed {
            sh "echo 'i run when there is a successful build after a failed one'"
            sh "echo 'or a failed build after a successful one'"
        }
    }
}
