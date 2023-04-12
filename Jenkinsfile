stages:
  - build

build:
  stage: build
  image:
    # 구글 공식 kaniko 이미지 repository 사용
    # debug 태그 이미지를 사용해야 파이프라인 출력 내용 확인 가능
    name: gcr.io/kaniko-project/executor:debug
    # entrypoint를 override 하지 않으면 아래 script 커맨드들이 실행되지 않음
    entrypoint: [""]
  script:
    # registry 접속 정보를 저장하기 위한 디렉토리 생성
    - mkdir -p /kaniko/.docker
    # Gitlab > Repository > Setting > CI/CD > Variables 사용
    HARBOR_URL : 10.0.1.150:5000
    HARBOR_USER : admin
    HARBOR_PASSWORD : Ketilinux11
    - echo "{\"auths\":{\"$HARBOR_URL\":{\"username\":\"$HARBOR_USER\",\"password\":\"$HARBOR_PASSWORD\"}}}" > /kaniko/.docker/config.json
    # Gitlab에 미리 정의된 Variables 사용
    # CI_PROJECT_DIR : Dockerfile을 포함한 Source Repositry 경로
    # CI_COMMIT_SHORT_SHA : Commit SHA의 앞 8자를 tag로 사용
    - /kaniko/executor --context $CI_PROJECT_DIR --dockerfile $CI_PROJECT_DIR/Dockerfile --destination $HARBOR_URL/sjjeon/kaniko
