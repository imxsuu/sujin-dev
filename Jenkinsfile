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
        containerTemplate(name: 'podman', image: 'ibmcase/podman:ubuntu-16.04', ttyEnabled: true, command: 'cat', privileged: true)
  ]) {

    node(podLabel) {
        checkout scm

        // Docker
        container(name:'podman', shell:'/bin/sh') {
            stage('Docker - Build Image') {
                sh """
                #!/bin/sh

                # Construct Image Name
                IMAGE=${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${env.BUILD_NUMBER}

                podman build -t \${IMAGE} .
                """
            }

            stage('Docker - Push Image to Registry') {
                sh """
                #!/bin/sh

                # Construct Image Name
                IMAGE=${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}:${env.BUILD_NUMBER}

                podman login -u admin -p Ketilinux11 ${REGISTRY} --tls-verify=false
           
                podman push \${IMAGE} --tls-verify=false
                """
            }
        }
    }
}
