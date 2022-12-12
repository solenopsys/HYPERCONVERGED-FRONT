FROM registry.alexstorm.solenopsys.org/hc-base:latest AS BUILD_APP
ARG MODULE_NAME
RUN echo "Module: ${MODULE_NAME}"

ARG DOCKER_REGISTRY="registry.alexstorm.solenopsys.org"
RUN echo "Docker registry: ${DOCKER_REGISTRY}"

ARG GIT_REPOSITORY="github.com/solenopsys"
RUN echo "Git repository: ${GIT_REPOSITORY}"
WORKDIR /softconverged
RUN git pull
RUN git submodule add -f https://${GIT_REPOSITORY}/sc-${MODULE_NAME} modules/${MODULE_NAME}
#RUN echo '{  "version": 2,  "projects": {"solenopsys": "modules/sc-fm-site" },"$schema": "./node_modules/nx/schemas/workspace-schema.json" }' > workspace.json
RUN nx  run ${MODULE_NAME}:build  --configuration=production


FROM nginx:latest  AS NGINX
COPY --from=BUILD_APP /softconverged/packages/fronts/${MODULE_NAME}/build/nginx.conf /etc/nginx/nginx.conf
COPY --from=BUILD_APP /softconverged/dist/packages/${MODULE_NAME} /var/www

CMD ["nginx"]







