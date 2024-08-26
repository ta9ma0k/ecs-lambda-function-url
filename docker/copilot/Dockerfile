# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

ARG APP_DIR=/app
ARG LOCAL_PATH=./api

ENV TZ=Asia/Tokyo
ENV RAILS_LOG_TO_STDOUT=1
ENV BUNDLE_DEPLOYMENT="1"
ENV BUNDLE_PATH="/usr/local/bundle"


# Throw-away build stage to reduce size of final image
FROM base AS build

WORKDIR $APP_DIR

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential default-libmysqlclient-dev git pkg-config

# Install application gems
COPY ${LOCAL_PATH}/Gemfile ${LOCAL_PATH}/Gemfile.lock ${APP_DIR}/
RUN bundle install --jobs=4 --without test development
RUN rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
# RUN bundle exec bootsnap precompile --gemfile

# Copy application code
COPY ${LOCAL_PATH} ${APP_DIR}

# Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
# RUN bin/rails assets:precompile


# Final stage for app image
FROM base

WORKDIR $APP_DIR

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl default-mysql-client libcap2-bin && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Abbreviate binstub settings
ENV PATH=/app/bin:$PATH

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build ${APP_DIR} ${APP_DIR}

# Run and own only the runtime files as a non-root user for security
RUN setcap CAP_NET_BIND_SERVICE+ep $(which ruby)

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails log tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["./bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/rails", "server", "-p", "80", "-b", "0.0.0.0"]
