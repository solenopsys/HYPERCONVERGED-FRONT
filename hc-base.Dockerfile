FROM alpine/git AS BUILD

RUN mkdir /app
WORKDIR /app
RUN git clone https://github.com/solenopsys/soft-converged-tree-repo
#RUN git submodule update --init --recursive
WORKDIR /app/soft-converged-tree-repo
RUN ls -alh /app/soft-converged-tree-repo

FROM node:latest AS RUN
RUN mkdir /softconverged
WORKDIR /softconverged
COPY --from=0 /app/soft-converged-tree-repo /softconverged
RUN ls -alh /softconverged
RUN npm config set fetch-retry-mintimeout 20000
RUN npm config set fetch-retry-maxtimeout 120000
RUN npm install --legacy-peer-deps
RUN npm install -g nx


