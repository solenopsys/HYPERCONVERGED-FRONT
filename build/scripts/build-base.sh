ARCHS="linux/amd64" #"linux/amd64,linux/arm64"
#REG_ADDRESS="registry.alexstorm.solenopsys.org"
REG_ADDRESS="466935361890.dkr.ecr.us-west-1.amazonaws.com/build-repo"

docker_base()
{
  docker buildx build --platform ${ARCHS}  --no-cache -t   ${REG_ADDRESS}/hc-base -f ./hc-base.Dockerfile --push ./
}

docker_base

