def app
node {        
    stage('Checkout'){            
        checkout scm            
    }
    
    stage('Build image'){                       
        app = docker.build("10.0.1.150:5000/sjjeon/jenkins-push")
    }
	
    stage('Push image'){ 
        docker.withRegistry('https://10.0.1.150:5000', 'harbor'){
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }                
    }		
}
