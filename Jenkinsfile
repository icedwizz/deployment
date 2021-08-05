pipeline {
    agent any

    stages {
        stage('Git-Checkout') {
            steps {
                    checkout scm
                    }
        }
        
        
        
        stage('Virtuoso') {
            steps {
                echo "######################### . Running  Virtuoso Execute  #######################"
                bat("${WORKSPACE}/Scripts/execute.sh -t=4191fb17-cdbf-4f6f-8244-48a62f967d30 -u=shane.wilson@viqtordavis.com -p=admin1234 --goal_id=6200")
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
