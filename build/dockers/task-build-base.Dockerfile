FROM alpine/git AS GIT_PULL
RUN mkdir /app
WORKDIR /app
RUN git clone https://github.com/solenopsys/soft-converged-tree-repo
WORKDIR /app/soft-converged-tree-repo

FROM docker  AS BUILD_CONTAINER
COPY --from=docker/buildx-bin:latest /buildx /usr/libexec/docker/cli-plugins/docker-buildx
RUN docker buildx version
RUN apk update && apk add bash
RUN mkdir /dist

WORKDIR /dist
COPY --from=GIT_PULL /app/soft-converged-tree-repo /dist
CMD ["bash", "/dist/build/scripts/build-base.sh"]
