
#GIT_ADDRESS="git.alexstorm.solenopsys.org"
GIT_ADDRESS="github.com/solenopsys"

connect_module()
{
  git submodule add -b master --force  https://$GIT_ADDRESS/sc-fm-$ITEM ./packages/modules/$ITEM
}




PROJECTS=""
#PROJECTS="${PROJECTS} rom-alexstorm"
#PROJECTS="${PROJECTS} backups-invicta"
#PROJECTS="${PROJECTS} clickhouse-invicta"
#PROJECTS="${PROJECTS} community-invicta"
#PROJECTS="${PROJECTS} content-invicta"
#PROJECTS="${PROJECTS} dgraph-invicta"
#PROJECTS="${PROJECTS} electronic-alexstorm"
#PROJECTS="${PROJECTS} equipment-invicta"
#PROJECTS="${PROJECTS} files-invicta"
#PROJECTS="${PROJECTS} git-invicta"
#PROJECTS="${PROJECTS} icons-invicta"
#PROJECTS="${PROJECTS} inventory-alexstorm"
#PROJECTS="${PROJECTS} kubernetes-invicta"
#PROJECTS="${PROJECTS} logs-invicta"
#PROJECTS="${PROJECTS} manufacturing"
#PROJECTS="${PROJECTS} postgres-invicta"
#PROJECTS="${PROJECTS} quality-invicta"
#PROJECTS="${PROJECTS} registry-invicta"
#PROJECTS="${PROJECTS} shockwaves-invicta"
#PROJECTS="${PROJECTS} storages-invicta"
#PROJECTS="${PROJECTS} time-alexstorm"
#PROJECTS="${PROJECTS} video-invicta"
PROJECTS="${PROJECTS} ci-invicta"
#docker_base

 for ITEM in $PROJECTS;do
   connect_module
 done
