ARCHS="linux/amd64,linux/arm64"
REG_ADDRESS="registry.alexstorm.solenopsys.org"

docker_base()
{
  docker buildx build --platform ${ARCHS}  --no-cache -t   registry.alexstorm.solenopsys.org/hc-base -f ./build/dockers/hc-base.Dockerfile --push ./
}

docker_build_push()
{
  echo "DOCKER BUILD $ITEM"

  docker buildx build  --no-cache --build-arg MODULE_NAME=$ITEM --platform ${ARCHS}  -t  $REG_ADDRESS/$ITEM -f ./build/dockers/fm.Dockerfile --push ./
}




gen_helm_from_template(){
  echo "HELM GEN TEMPLATE $FILE"
  rm -rf ./dist/helm/$ITEM
  cp -r  ./build/template ./dist/helm/$ITEM
  cd ./dist/helm/$ITEM
  sed -i "s/@name/$ITEM/g" *.yaml
  cd ../../../
}

helm_package-push()
{
  echo "HELM PACKAGE $ITEM"
  res=$(helm package ./dist/helm/$ITEM -d ./dist/helm/$ITEM)
  echo "RES $res"

  file=${res/Successfully packaged chart and saved it to: /}
  echo "HELM PUSH $file"
  curl --data-binary "@$file" http://helm.alexstorm.solenopsys.org/api/charts
}





all_projects(){
  PROJECTS=""
  PROJECTS="${PROJECTS} alexstorm-hcfm-rom"
#  PROJECTS="${PROJECTS} alexstorm-hcfm-backups"
  PROJECTS="${PROJECTS} alexstorm-hcfm-clickhouse"
  PROJECTS="${PROJECTS} alexstorm-hcfm-community"
  PROJECTS="${PROJECTS} alexstorm-hcfm-content"
  PROJECTS="${PROJECTS} alexstorm-hcfm-dgraph"
  PROJECTS="${PROJECTS} alexstorm-hcfm-electronic"
  PROJECTS="${PROJECTS} alexstorm-hcfm-equipment"
  PROJECTS="${PROJECTS} alexstorm-hcfm-exhibition"
  PROJECTS="${PROJECTS} alexstorm-hcfm-files"
  PROJECTS="${PROJECTS} alexstorm-hcfm-git"
  PROJECTS="${PROJECTS} alexstorm-hcfm-icons"
  PROJECTS="${PROJECTS} alexstorm-hcfm-inventory"
  PROJECTS="${PROJECTS} alexstorm-hcfm-kubernetes"
  PROJECTS="${PROJECTS} alexstorm-hcfm-logs"
  PROJECTS="${PROJECTS} alexstorm-hcfm-ci"
  PROJECTS="${PROJECTS} alexstorm-hcfm-manufacturing"
  PROJECTS="${PROJECTS} alexstorm-hcfm-postgres"
  PROJECTS="${PROJECTS} alexstorm-hcfm-quality"
  PROJECTS="${PROJECTS} alexstorm-hcfm-registry"
  PROJECTS="${PROJECTS} alexstorm-hcfm-shockwaves"
  PROJECTS="${PROJECTS} alexstorm-hcfm-storages"
  PROJECTS="${PROJECTS} alexstorm-hcfm-time"
  PROJECTS="${PROJECTS} alexstorm-hcfm-video"

   for ITEM in $PROJECTS;do
      docker_build_push
#      gen_helm_from_template
#      helm_package-push
   done

}






#docker_base
all_projects
