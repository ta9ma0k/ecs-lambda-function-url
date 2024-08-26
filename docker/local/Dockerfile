FROM ruby:3.3.0-slim

ARG APP_DIR=/app \
    LOCAL_PATH=./api

ENV TZ=Asia/Tokyo \
    RAILS_LOG_TO_STDOUT=1

RUN set -ex \
  && apt-get update \
  && apt-get install -y curl gnupg vim \
  && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get install -y default-libmysqlclient-dev build-essential nodejs shared-mime-info libvips42 \
  && npm i -g yarn \
  && gem install bundler

WORKDIR $APP_DIR

COPY ${LOCAL_PATH}/Gemfile ${LOCAL_PATH}/Gemfile.lock ${APP_DIR}/
RUN set -ex \
  && bundle install --jobs=2
