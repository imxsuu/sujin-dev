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
                            url: 'http://root:ketilinux@10.0.2.121:80/ketiops/manifest.git',
                            credentialsId: 'jenkins-ssh',
                        ]]
                ])
                sshagent(credentials: ['jenkins-ssh']){
                    sh("""
			#!/usr/bin/env bash
                        set +x
                        export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=no"
                        git config --global user.email "admin@example.com"
                        git checkout main
                        cd env/dev && kustomize edit set image 10.0.1.150:5000/sjjeon/argocd-deploy:${BUILD_NUMBER}
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
