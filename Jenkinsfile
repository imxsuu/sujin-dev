def app
node {        
    stage('Checkout'){            
        checkout scm            
    }
    
    stage('Build image'){
        podman build -t 10.0.1.150:5000/sjjeon/jenkins-test . --tls-verify=false
    }
	
    stage('Push image'){ 
        docker.withRegistry('https://10.0.1.150:5000', 'harbor'){
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }                
    }		
}
