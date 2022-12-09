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
  PROJECTS="${PROJECTS} rom-alexstorm"
  PROJECTS="${PROJECTS} backups-invicta"
#  PROJECTS="${PROJECTS} clickhouse-invicta"
#  PROJECTS="${PROJECTS} community-invicta"
#  PROJECTS="${PROJECTS} content-invicta"
#  PROJECTS="${PROJECTS} dgraph-invicta"
#  PROJECTS="${PROJECTS} electronic-alexstorm"
#  PROJECTS="${PROJECTS} equipment-invicta"
#  PROJECTS="${PROJECTS} files-invicta"
#  PROJECTS="${PROJECTS} gi-invicta"
#  PROJECTS="${PROJECTS} inventory-invicta"
#  PROJECTS="${PROJECTS} kubernetes-invicta"
#  PROJECTS="${PROJECTS} logs-invicta"
#  PROJECTS="${PROJECTS} ci-invicta"
#  PROJECTS="${PROJECTS} manufacturing-invicta"
#  PROJECTS="${PROJECTS} postgres-invicta"
#  PROJECTS="${PROJECTS} quality-invicta"
#  PROJECTS="${PROJECTS} registry-invicta"
#  PROJECTS="${PROJECTS} shockwaves-invicta"
#  PROJECTS="${PROJECTS} storages-invicta"
#  PROJECTS="${PROJECTS} time-alexstorm"
#  PROJECTS="${PROJECTS} video-invicta"

   for ITEM in $PROJECTS;do
     docker_build_push
     gen_helm_from_template
     helm_package-push
   done

}

#docker_base
all_projects
