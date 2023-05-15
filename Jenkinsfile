// Pod Template
def podLabel = "web"
def cloud = env.CLOUD ?: "kubernetes"
def registryCredsID = env.REGISTRY_CREDENTIALS ?: "registry-credentials-id"
def serviceAccount = env.SERVICE_ACCOUNT ?: "jenkins-admin"

// Pod Eironment Variables
def namespace = env.NAMESPACE ?: "sjjeon"
def registry = env.REGISTRY ?: "10.0.1.150:5000"
def imageName1 = env.IMAGE_NAME1 ?: "podman"
def imageName2 = env.IMAGE_NAME2 ?: "argocd"


podTemplate(label: 'podman-argocd',
  containers: [
    containerTemplate(
      name: 'podman',
      image: 'mgoltzsche/podman',
      command: 'cat',
      ttyEnabled: true,
      privileged: true
    ),
    containerTemplate(
      name: 'argocd',
      image: 'argoproj/argo-cd-ci-builder:latest',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
) {
    node('podman-argocd') {
        def dockerHubCred = "dockerhub_cred"
        def appImage
        
        stage('Checkout'){
            container('argocd'){
                checkout scm
            }
        }
        
        stage('Build'){
            container('podman'){
                sh("""
                    #!/bin/sh

                    # Construct Image Name
                    IMAGE=10.0.1.150:5000/sjjeon/argocd-deploy:${env.BUILD_NUMBER}
                    
                    podman build -t \${IMAGE} .
                """)
            }
        }

        stage('Push'){
            container('podman'){
                sh("""
                    #!/bin/sh

                    # Construct Image Name
                    IMAGE=10.0.1.150:5000/sjjeon/argocd-deploy:${env.BUILD_NUMBER}
                   
                    podman login -u admin -p Ketilinux11 10.0.1.150:5000 --tls-verify=false

                    podman push \${IMAGE} --tls-verify=false
                """)
            }
        }
        

        stage('Deploy'){
            container('argocd'){
                checkout([$class: 'GitSCM',
                        branches: [[name: '*/main' ]],
                        extensions: scm.extensions,
                        userRemoteConfigs: [[
                            url: 'http://10.0.2.121:80/ketiops/imxsuu.git',
                            credentialsId: 'gitlab',
                        ]]
                ])
                sshagent(credentials: ['jenkins-ssh']){
                    sh("""
                        git checkout main
                        sed -i 's/argocd-deploy:.*\$/argocd-deploy:${currentBuild.number}/g' deployment.yaml
                        git add deployment.yaml
                        git commit -m "[UPDATE] change the image versioning ${currentBuild.number}"
                        git push
                    """)
                }
            }
        }
    } 
}
