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
		 //echo "${WORKSPACE}/Scripts/buildRelease.sh"
                 //sh "chmod +x -R ${env.WORKSPACE}"
                 bat("${WORKSPACE}/Scripts/buildRelease.ps1 -apiKey=tjO4XFM.YyIj1DidmcCRB72RMUISPtPLaoVD4IhE4Yx -serverBase=http://localhost:8088/semarchy -modelName=DemoTest -devModelEdition=0.1 -o='Models' -r='Building release for DemoTest [0.1]'")
                 }
        }
        
         stage('Test-Release') {
             steps {
                echo "########################## 3. Running  Test-Release ##########################"
                //sh chmod +x -R ${env.WORKSPACE}"
                bat("${WORKSPACE}/Scripts/testRelease.sh -apiKey=tjO4XFM.YyIj1DidmcCRB72RMUISPtPLaoVD4IhE4Yx -serverBase=http://localhost:8088/semarchy -dataLocation='DemoTest' -modelName=DemoTest")
             }
	    }
        
        stage('Virtuoso') {
            steps {
                echo "######################### . Running  Virtuoso Execute  #######################"
                bat("${WORKSPACE}/Scripts/execute.sh -t 4191fb17-cdbf-4f6f-8244-48a62f967d30 -u shane.wilson@viqtordavis.com -p admin1234 --goal_id 6200")
            }
        }
	
	    stage('Git-Checkin') {
            steps {
                echo "########################## 4. Running  Git-Checkin ##########################"
                withCredentials([usernamePassword(credentialsId: '985b7153-e495-47cd-8ca1-b7af13fdab57', usernameVariable: 'Username', passwordVariable: 'Password')]) {
                bat("git add --all")
                bat('git commit -am "new model added"')
                bat("git status")
                bat("git push --set-upstream https://${Username}:${Password}@https://github.com/icedwizz/deployment.git dev")
            }
        }
	    }
    }
}
postFailure = {
    echo "Semarchy Dev-Pipeline failed"
}

postAlways = {
    echo "I always run"
}
    
