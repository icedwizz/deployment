pipeline {
    agent any

    stages {
        stage('Git-Checkout') {
            steps {
                    echo "########################## 1. Running  Git-Checkout ##########################"
                    sh("git branch")
                    sh "git reset --hard"
                    sh "git checkout dev"
                    sh "git pull"
                    }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
