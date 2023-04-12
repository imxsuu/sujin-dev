stages:
  - build

build:
  stage: build
  image:
    name: gcr.io/kaniko-project/executor:debug
    entrypoint: [""]
  script:
    - mkdir -p /kaniko/.docker
    HARBOR_URL : 10.0.1.150:5000
    HARBOR_USER : admin
    HARBOR_PASSWORD : Ketilinux11
    - echo "{\"auths\":{\"$HARBOR_URL\":{\"username\":\"$HARBOR_USER\",\"password\":\"$HARBOR_PASSWORD\"}}}" > /kaniko/.docker/config.json
    - /kaniko/executor --context $CI_PROJECT_DIR --dockerfile $CI_PROJECT_DIR/Dockerfile --destination $HARBOR_URL/sjjeon/kaniko
