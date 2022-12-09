ARCHS="linux/amd64,linux/arm64"
REG_ADDRESS="registry.alexstorm.solenopsys.org"

docker_base()
{
  docker buildx build --platform ${ARCHS}  --no-cache -t   $REG_ADDRESS/hc-base -f ./build/dockers/hc-base.Dockerfile --push ./
}

docker_build_push()
{
  echo "DOCKER BUILD $ITEM"
  docker buildx build  --no-cache --build-arg MODULE_NAME=$ITEM --build-arg DOCKER_REGISTRY=registry.alexstorm.solenopsys.org  --build-arg GIT_REPOSITORY=github.com/solenopsys --platform ${ARCHS}  -t  $REG_ADDRESS/$ITEM -f ./build/dockers/fm.Dockerfile --push ./
}


gen_helm_from_template()
{
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
  PROJECTS="${PROJECTS} sc-fm-rom-alexstorm"
  PROJECTS="${PROJECTS} sc-fm-backups-invicta"
#  PROJECTS="${PROJECTS} sc-fm-clickhouse-invicta"
#  PROJECTS="${PROJECTS} sc-fm-community-invicta"
#  PROJECTS="${PROJECTS} sc-fm-content-invicta"
#  PROJECTS="${PROJECTS} sc-fm-dgraph-invicta"
#  PROJECTS="${PROJECTS} sc-fm-electronic-alexstorm"
#  PROJECTS="${PROJECTS} sc-fm-equipment-invicta"
#  PROJECTS="${PROJECTS} sc-fm-files-invicta"
#  PROJECTS="${PROJECTS} sc-fm-gi-invicta"
#  PROJECTS="${PROJECTS} sc-fm-inventory-invicta"
#  PROJECTS="${PROJECTS} sc-fm-kubernetes-invicta"
#  PROJECTS="${PROJECTS} sc-fm-logs-invicta"
#  PROJECTS="${PROJECTS} sc-fm-ci-invicta"
#  PROJECTS="${PROJECTS} sc-fm-manufacturing-invicta"
#  PROJECTS="${PROJECTS} sc-fm-postgres-invicta"
#  PROJECTS="${PROJECTS} sc-fm-quality-invicta"
#  PROJECTS="${PROJECTS} sc-fm-registry-invicta"
#  PROJECTS="${PROJECTS} sc-fm-shockwaves-invicta"
#  PROJECTS="${PROJECTS} sc-fm-storages-invicta"
#  PROJECTS="${PROJECTS} sc-fm-time-alexstorm"
#  PROJECTS="${PROJECTS} sc-fm-video-invicta"

   for ITEM in $PROJECTS;do
     docker_build_push
     gen_helm_from_template
     helm_package-push
   done

}

#docker_base
all_projects
