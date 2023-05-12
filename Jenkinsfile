// Pod Template
def podLabel = "web"
def cloud = env.CLOUD ?: "kubernetes"
def registryCredsID = env.REGISTRY_CREDENTIALS ?: "registry-credentials-id"
def serviceAccount = env.SERVICE_ACCOUNT ?: "jenkins-admin"

// Pod Environment Variables
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
      ttyEnabled: true
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
                script {
                    # Construct Image Name
                    IMAGE = ${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${env.BUILD_NUMBER}
                    
                    podman build -t \${IMAGE} .
                }
            }
        }

        stage('Push'){
            container('podman'){
                script {
                    # Construct Image Name
                    IMAGE = ${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${env.BUILD_NUMBER}
                   
                    podman login -u admin -p Ketilinux11 ${REGISTRY} --tls-verify=false

                    podman push \${IMAGE} --tls-verify=false
                    }
                }
            }
        }

        stage('Deploy'){
            container('argo'){
                checkout([$class: 'GitSCM',
                        branches: [[name: '*/main' ]],
                        extensions: scm.extensions,
                        userRemoteConfigs: [[
                            url: 'git@10.0.2.121:80:ketiops/imxsuu.git',
                            credentialsId: 'gitlab',
                        ]]
                ])
                sshagent(credentials: ['gitlab']){
                    sh("""
                        #!/usr/bin/env bash
                        set +x
                        export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=no"
                        git config --global user.email "imxsuu@gmail.com"
                        git checkout main
                        cd env/dev && kustomize edit set image sjjeon/podman:${BUILD_NUMBER}
                        git commit -a -m "[UPDATE] change the image tag"
                        git push
                    """)
                }
            }
        }
    } 
}
