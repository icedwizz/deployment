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
        
        stage('Build-Release') {
            steps {
                 echo "########################## 2. Running  Build-Release ##########################"
                 sh "chmod +x -R ${env.WORKSPACE}"
                 sh "${WORKSPACE}/Scripts/buildRelease.sh -apiKey=tjO4XFM.YyIj1DidmcCRB72RMUISPtPLaoVD4IhE4Yx -serverBase=http://localhost:8088/semarchy -modelName=DemoTest -devModelEdition=0.1 -o='Models' -r='Building release for DemoTest [0.1]'"
                 }
        }
        stage('Test') {
            steps {
                echo "######################### 3. Running  Virtuoso Execute  #######################"
                sh "${WORKSPACE}/Scripts/execute.sh -t=4191fb17-cdbf-4f6f-8244-48a62f967d30 -u=shane.wilson@viqtordavis.com -p=admin1234 --goal_id=6200"
            }
        }
    }
}
