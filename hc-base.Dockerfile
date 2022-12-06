FROM alpine/git AS BUILD

RUN mkdir /app
WORKDIR /app
RUN git clone https://github.com/solenopsys/soft-converged-tree-repo
RUN git submodule update --init --recursive
WORKDIR /app/soft-converged-tree-repo
RUN ls -alh /app/soft-converged-tree-repo

FROM node AS RUN
RUN mkdir /softconverged
WORKDIR /softconverged
COPY --from=0 /app/soft-converged-tree-repo /softconverged
RUN ls -alh /softconverged
RUN npm install --legacy-peer-deps
RUN npm install -g nx


