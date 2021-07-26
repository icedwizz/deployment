pipeline = {

	stages {
	
    stage('Git-Checkout'){
      echo "########################## 1. Running  Git-Checkout ##########################"
       sh("git branch")
       sh "git reset --hard"
       sh "git checkout dev"
       sh "git pull"
       
    }
    
    stage('Build-Release') {
       
        echo "########################## 2. Running  Build-Release ##########################"
        sh "chmod +x -R ${env.WORKSPACE}"
      
       
        sh "${WORKSPACE}/Scripts/buildRelease.sh -apiKey=tjO4XFM.YyIj1DidmcCRB72RMUISPtPLaoVD4IhE4Yx -serverBase=http://localhost:8088/semarchy -modelName=DemoTest -devModelEdition=0.1 -r='Building release for DemoTest [0.1]'"
        
	
       
    }

    stage('Test-Release') {
        echo "########################## 3. Running  Test-Release ##########################"
        sh "chmod +x -R ${env.WORKSPACE}"
        sh "${WORKSPACE}/Scripts/testRelease.sh -apiKey=tjO4XFM.YyIj1DidmcCRB72RMUISPtPLaoVD4IhE4Yx -serverBase=http://localhost:8088/semarchy -dataLocation='DemoTest' -modelName=DemoTest"

	}
	
	stage('Git-Checkin') {
        echo "########################## 4. Running  Git-Checkin ##########################"
        withCredentials([usernamePassword(credentialsId: 'icedwizz', usernameVariable: 'Username', passwordVariable: 'Password')]) {
       
        
       
        sh("git add --all")
        sh("git commit -a -m 'new model added'")
        sh("git status")
        
        sh("git push --set-upstream https://${Username}:${Password}@https://github.com/icedwizz/deployment.git dev")
        
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


   
