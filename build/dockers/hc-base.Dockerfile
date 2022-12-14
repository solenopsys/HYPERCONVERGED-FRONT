# example git.alexstorm.solenopsys.org

FROM alpine/git AS BUILD
ARG GIT_REPOSITORY="github.com/solenopsys"
RUN echo "Git repository: ${GIT_REPOSITORY}"
RUN mkdir /app
WORKDIR /app
RUN git clone https://${GIT_REPOSITORY}/soft-converged-tree-repo
#RUN git submodule update --init --recursive
WORKDIR /app/soft-converged-tree-repo
RUN git submodule update --force --recursive --init --remote
RUN ls -alh /app/soft-converged-tree-repo

FROM node:18.12.1 AS RUN
RUN mkdir /softconverged
WORKDIR /softconverged
COPY --from=0 /app/soft-converged-tree-repo /softconverged
RUN npm install --legacy-peer-deps
RUN npm install -g nx
RUN cd packages/libs/helm && npm install  --legacy-peer-deps
RUN cd packages/libs/hyperstreams && npm install  --legacy-peer-deps
RUN cd packages/uimatrix/editors/code && npm install  --legacy-peer-deps
RUN cd packages/uimatrix/lists && npm install  --legacy-peer-deps
RUN cd packages/uimatrix/modals && npm install  --legacy-peer-deps


