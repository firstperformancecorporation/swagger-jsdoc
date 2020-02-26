FROM 739760443361.dkr.ecr.us-east-1.amazonaws.com/fp-docker-component-base:latest
ENV SRC_CODE="./"
ENV APP_DIR="/var/app/current/"

COPY ${SRC_CODE} ${APP_DIR}

# Install nvm with node and npm
WORKDIR ${APP_DIR}

RUN source $NVM_DIR/nvm.sh

RUN source $NVM_DIR/nvm.sh \
    && NODE_VERSION=`cat ${APP_DIR}package.json | jq -r .engines.node` \
    && NPM_VERSION=`cat ${APP_DIR}package.json | jq -r .engines.npm` \
    && nvm install $NODE_VERSION \
    && npm install npm@${NPM_VERSION} -g \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && ln -sfn `nvm which node | sed 's/bin\/node/bin\/npm/g'` /usr/bin/npm \
    && ln -sfn `nvm which node` /usr/bin/node

RUN npm ci

