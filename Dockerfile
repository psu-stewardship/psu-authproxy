## BUILD Container
FROM node:12.16.1-alpine3.9 as nodejs

FROM ruby:2.6.5-alpine as build

ENV BUNDLE_APP_CONFIG="/app/.bundle"
WORKDIR /app

ENV TZ=America/New_York

RUN apk add --no-cache \
    curl \
    libxml2-dev \
    libxslt-dev \
    build-base \
    postgresql-dev  \
    bash \
    tzdata
  
### NodeJS
COPY --from=nodejs /usr/local/lib /usr/local/lib
COPY --from=nodejs /usr/local/bin /usr/local/bin
COPY --from=nodejs /opt /opt

### Envconsul
RUN curl -Lo /tmp/envconsul.zip https://releases.hashicorp.com/envconsul/0.9.0/envconsul_0.9.0_linux_amd64.zip && \
    unzip /tmp/envconsul.zip -d /bin && \
    rm /tmp/envconsul.zip

RUN gem install bundler:2.0.2

RUN addgroup -g 1000 app
RUN adduser -S -G app --uid 1000 --home /app app
RUN chown -R app /app
USER app

ADD Gemfile Gemfile.lock /app/
RUN bundle install --path vendor/bundle && \
    rm -rf vendor/bundle/ruby/2.6.0/cache/*.gem && \
    find vendor/bundle/ruby/2.6.0/gems/ -name "*.c" -delete && \
    find vendor/bundle/ruby/2.6.0/gems/ -name "*.o" -delete && \
    rm -rf /app/.bundle/cache && \
    rm -rf /app/tmp


ADD --chown=app . /app/

CMD ["./entrypoint.sh"]


FROM build as production 

RUN RAILS_ENV=production OIDC_ISSUER=localhost OIDC_SIGNING_KEY="Zm9vCg==" SECRET_KEY_BASE=$(bundle exec rails secret) bundle exec rails assets:precompile

CMD ["./entrypoint.sh"]

FROM ruby:2.6.5-alpine as app
ENV BUNDLE_APP_CONFIG="/app/.bundle"
WORKDIR /app

RUN apk --no-cache add \
    tzdata postgresql-client xz-libs

RUN gem install bundler:2.0.2
RUN addgroup -g 1000 app
RUN adduser -S -G app --uid 1000 --home /app app
RUN chown -R app /app
USER app

COPY --from=nodejs /usr/local/lib /usr/local/lib
COPY --from=nodejs /usr/local/bin /usr/local/bin

COPY --from=production /bin/envconsul /bin
COPY --from=production --chown=app /app /app
RUN bundle install --path vendor/bundle

CMD ["./entrypoint.sh"]

