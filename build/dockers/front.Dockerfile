FROM registry.alexstorm.solenopsys.org/hc-base:latest AS BUILD_APP
ARG MODULE_NAME
RUN echo "Module: ${MODULE_NAME}"

ARG DOCKER_REGISTRY="registry.alexstorm.solenopsys.org"
RUN echo "Docker registry: ${DOCKER_REGISTRY}"

ARG GIT_REPOSITORY="github.com/solenopsys"
RUN echo "Git repository: ${GIT_REPOSITORY}"
WORKDIR /softconverged
RUN git pull


RUN rm -rf packages/fronts/${MODULE_NAME}
RUN git submodule add  -f https://${GIT_REPOSITORY}/sc-${MODULE_NAME} packages/fronts/${MODULE_NAME}
RUN git submodule update --remote --merge packages/fronts/${MODULE_NAME}

RUN cd packages/fronts/${MODULE_NAME} && npm install
RUN nx run ${MODULE_NAME}:build --configuration=production  --skip-nx-cache
RUN ls /softconverged/packages/fronts/${MODULE_NAME}/build/

FROM nginx:latest  AS NGINX

COPY --from=BUILD_APP /softconverged/dist/packages/${MODULE_NAME} /var/www
COPY --from=BUILD_APP /softconverged/packages/fronts/${MODULE_NAME}/build/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx"]







