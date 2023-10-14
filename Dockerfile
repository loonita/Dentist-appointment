FROM ruby:3.2.2

ENV NODE_VERSION=16.13.0
ENV NVM_DIR=/root/.nvm
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN apt-get update -y
RUN apt-get upgrade -y

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}

RUN npm install -g yarn

RUN git clone https://github.com/loonita/Dentist-appointment /usr/src/app
WORKDIR /usr/src/app

RUN gem update --system
RUN gem install bundler
RUN bundler config set force_ruby_platform true
RUN bundler


RUN yarn install

EXPOSE 3000
