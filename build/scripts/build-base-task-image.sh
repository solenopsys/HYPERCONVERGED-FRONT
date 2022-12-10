ARCHS="linux/amd64" #"linux/amd64,linux/arm64"
REG_ADDRESS="registry.alexstorm.solenopsys.org"

docker_base()
{
  docker buildx build --platform ${ARCHS}  --no-cache -t   ${REG_ADDRESS}/task-build-base -f ./build/dockers/task-build-base.Dockerfile --push ./build/dockers/
}

docker_base

