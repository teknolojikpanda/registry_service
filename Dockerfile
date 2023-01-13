FROM --platform=linux/arm64 ruby:2.3.6-stretch
MAINTAINER Mike Heijmans <parabuzzle@gmail.com> - TeknolojikPanda <dogaucak@gmail.com>

ENV PORT=80 \
    REGISTRY_HOST=172.18.0.2 \
    REGISTRY_PORT=5000 \
    REGISTRY_PROTOCOL=http \
    SSL_VERIFY=false \
    ALLOW_REGISTRY_LOGIN=false \
    REGISTRY_SSL_VERIFY=true \
    REGISTRY_ALLOW_DELETE=true \
    APP_HOME=/webapp

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY . $APP_HOME

RUN apt update && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt install -y nodejs npm g++ musl-dev make build-essential && \
    npm install --no-optional && \
    node_modules/.bin/webpack && \
    rm -rf node_modules && \
    gem update bundler && \
    bundle install --deployment && \
    apt remove -y nodejs g++ musl-dev make build-essential 

CMD ["bundle", "exec", "foreman", "start"]