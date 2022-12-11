ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
REPOSITORY=build-repo
REGION=us-west-1


#466935361890.dkr.ecr.us-west-1.amazonaws.com/build-repo

cat << EOF | kubectl create -f -
apiVersion: v1
kind: Pod
metadata:
  name: kaniko-eks
spec:
  restartPolicy: Never
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:v1.0.0
    imagePullPolicy: Always
    args: ["--dockerfile=Dockerfile",
            "--context=git://github.com/carlossg/kaniko-demo.git",
            "--destination=${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY}/kaniko-demo:latest",
            "--cache=true"]
    volumeMounts:
      - name: docker-config
        mountPath: /kaniko/.docker/
    resources:
      limits:
        cpu: 1
        memory: 1Gi
  volumes:
    - name: docker-config
      configMap:
        name: docker-config
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: docker-config
data:
  config.json: |-
    { "credsStore": "ecr-login" }
EOF