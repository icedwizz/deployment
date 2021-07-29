pipeline {
    agent any

    stages {
        stage('Git-Checkout') {
            steps {
                    echo "########################## 1. Running  Git-Checkout ##########################"
                    bat ("git branch")
                    bat "git reset --hard"
                    bat "git checkout dev"
                    bat "git pull"
                    }
        }
        
        stage('Build-Release') {
            steps {
                 echo "########################## 2. Running  Build-Release ##########################"
                 //bat "sh chmod +x -R ${env.WORKSPACE}"
                 bat "${WORKSPACE}/Scripts/buildRelease.sh -apiKey=tjO4XFM.YyIj1DidmcCRB72RMUISPtPLaoVD4IhE4Yx -serverBase=http://localhost:8088/semarchy -modelName=DemoTest -devModelEdition=0.1 -o='Models' -r='Building release for DemoTest [0.1]'"
                 }
        }
        
        
	}
}
