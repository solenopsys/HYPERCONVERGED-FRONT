

FROM registry.alexstorm.solenopsys.org/hc-base:latest AS BUILD_APP
ARG MODULE_NAME
RUN echo "Module: ${MODULE_NAME}"

# example: registry.alexstorm.solenopsys.org
ARG DOCKER_REGISTRY
RUN echo "Docker registry: ${DOCKER_REGISTRY}"

# example git.alexstorm.solenopsys.org
ARG GIT_REPOSITORY
RUN echo "Git repository: ${GIT_REPOSITORY}"
WORKDIR /softconverged
RUN git pull
RUN rm ./workspace.json
RUN echo '{  "version": 2,  "projects": {"'${MODULE_NAME}'": "packages/modules/'${MODULE_NAME}'" },"$schema": "./node_modules/nx/schemas/workspace-schema.json" }'>./workspace.json
RUN git submodule add  -f https://${GIT_REPOSITORY}/${MODULE_NAME} packages/modules/${MODULE_NAME}
RUN nx build ${MODULE_NAME} --configuration=production  --skip-nx-cache

FROM busybox  AS BUILD_CONTAINER
RUN mkdir /dist
WORKDIR /dist
COPY --from=BUILD_APP /softconverged/dist /dist
