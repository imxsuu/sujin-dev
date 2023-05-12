// Pod Template
def podLabel = "web"
def cloud = env.CLOUD ?: "kubernetes"
def registryCredsID = env.REGISTRY_CREDENTIALS ?: "registry-credentials-id"
def serviceAccount = env.SERVICE_ACCOUNT ?: "jenkins-admin"

// Pod Environment Variables
def namespace = env.NAMESPACE ?: "sjjeon"
def registry = env.REGISTRY ?: "10.0.1.150:5000"
def imageName = env.IMAGE_NAME ?: "podman"

/*
  Optional Pod Environment Variables
 */
def helmHome = env.HELM_HOME ?: env.JENKINS_HOME + "/.helm"

podTemplate(label: podLabel, cloud: cloud, serviceAccount: serviceAccount, envVars: [
        envVar(key: 'NAMESPACE', value: namespace),
        envVar(key: 'REGISTRY', value: registry),
        envVar(key: 'IMAGE_NAME', value: imageName)
    ],
    containers: [
        // containerTemplate(name: 'podman', image: 'ibmcase/podman:ubuntu-16.04', ttyEnabled: true, command: 'cat', privileged: true) 
        containerTemplate(name: 'podman', image: 'mgoltzsche/podman', ttyEnabled: true, command: 'cat', privileged: true),
        // Add ArgoCD container
        containerTemplate(name: 'argocd', image: 'argoproj/argo-cd-ci-builder:latest', command: 'cat', ttyEnabled: true), 
  ]) {

    node(podLabel) {
        checkout scm

        // Podman
        container(name:'podman', shell:'/bin/sh') {
            stage('Podman - Build Image') {
                sh """
                #!/bin/sh

                # Construct Image Name
                IMAGE=${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${env.BUILD_NUMBER}

                podman build -t \${IMAGE} .
                """
            }

            stage('Podman - Push Image to Harbor') {
                sh """
                #!/bin/sh

                # Construct Image Name
                IMAGE=${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${env.BUILD_NUMBER}

                podman login -u admin -p Ketilinux11 ${REGISTRY} --tls-verify=false
           
                podman push \${IMAGE} --tls-verify=false
                """
            }
        }
        
        //ArgoCD
        container('argocd') {
            stage('K8S Manifest Update') {
                    git credentialsId: 'gitlab',
                        url: 'http://10.0.2.121:80/ketiops/imxsuu.git',
                        branch: 'main'
                    sh "sed -i 's/my-app:.*\$/my-app:${currentBuild.number}/g' deployment.yaml"
                    sh "git add deployment.yaml"
                    sh "git commit -m '[UPDATE] my-app ${currentBuild.number} image versioning'"
                    sshagent(credentials: ['gitlab']) {
                        sh "git remote set-url origin git@10.0.2.121:80:ketiops/imxsuu.git"
                        sh "git push -u origin master"
                    }
            }
            post {
                    failure {
                      echo 'K8S Manifest Update failure !'
                    }
                    success {
                      echo 'K8S Manifest Update success !'
                    }
            }
         
        }
    }
}
