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
        
        
        
        stage('Virtuoso') {
            steps {
                echo "######################### . Running  Virtuoso Execute  #######################"
                bat("${WORKSPACE}/Scripts/execute.sh -t=4191fb17-cdbf-4f6f-8244-48a62f967d30 -u=shane.wilson@viqtordavis.com -p=admin1234 --goal_id=6200")
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
