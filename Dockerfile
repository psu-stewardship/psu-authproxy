
ARG BUNDLER_VERSION=2.0.2

## BUILD Container
FROM ruby:2.6.5-alpine as build

ENV BUNDLE_APP_CONFIG="/app/.bundle"
WORKDIR /app

ENV TZ=America/New_York

RUN apk add --no-cache \
    curl \
    nodejs  \
    yarn \
    libxml2-dev \
    libxslt-dev \
    build-base \
    postgresql-dev  \
    bash \
    tzdata
  

### Envconsul
RUN curl -Lo /tmp/envconsul.zip https://releases.hashicorp.com/envconsul/0.9.0/envconsul_0.9.0_linux_amd64.zip && \
    unzip /tmp/envconsul.zip -d /bin && \
    rm /tmp/envconsul.zip

RUN gem install bundler:2.0.2

RUN addgroup -g 9999 app
RUN adduser -S --uid 9999 --home /app app app
RUN chown -R app /app
USER app

ADD Gemfile Gemfile.lock /app/
RUN bundle install --path vendor/bundle && \
    rm -rf vendor/bundle/ruby/2.6.0/cache/*.gem && \
    find vendor/bundle/ruby/2.6.0/gems/ -name "*.c" -delete && \
    find vendor/bundle/ruby/2.6.0/gems/ -name "*.o" -delete

ADD --chown=app . /app/

CMD ["./entrypoint.sh"]


FROM build as production 

RUN RAILS_ENV=production OIDC_ISSUER=localhost OIDC_SIGNING_KEY="Zm9vCg==" SECRET_KEY_BASE=$(bundle exec rails secret) bundle exec rails assets:precompile

CMD ["./entrypoint.sh"]

FROM ruby:2.6.5-alpine as app
ENV BUNDLE_APP_CONFIG="/app/.bundle"
WORKDIR /app

RUN apk --no-cache add \
    nodejs tzdata postgresql-client xz-libs

RUN gem install bundler:2.0.2
RUN addgroup -g 9999 app
RUN adduser -S --uid 9999 --home /app app app
RUN chown -R app /app
USER app

COPY --from=production /bin/envconsul /bin
COPY --from=production --chown=app /app /app
RUN bundle install --path vendor/bundle

CMD ["./entrypoint.sh"]

