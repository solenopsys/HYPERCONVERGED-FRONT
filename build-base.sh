ARCHS="linux/amd64" #"linux/amd64,linux/arm64"
REG_ADDRESS="registry.alexstorm.solenopsys.org"

docker_base()
{
  docker buildx build --platform ${ARCHS}  --no-cache -t   registry.alexstorm.solenopsys.org/hc-base -f ./hc-base.Dockerfile --push ./
}

docker_base

