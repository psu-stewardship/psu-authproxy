FROM ruby:2.6.5 as base

WORKDIR /app

ENV TZ=America/New_York

ENV PACKAGES='curl unzip zlib1g-dev'

RUN apt-get update && \
  apt-get -y --no-install-recommends install $PACKAGES && \
  rm -rf /var/lib/apt/lists/*

### Envconsul
RUN curl -Lo /tmp/envconsul.zip https://releases.hashicorp.com/envconsul/0.9.0/envconsul_0.9.0_linux_amd64.zip && \
    unzip /tmp/envconsul.zip -d /bin && \
    rm /tmp/envconsul.zip

## NodeJS
ENV NODE_VERSION 12.13.0
RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN npm install -g yarn@1.19.1

RUN gem install bundler:2.0.2

RUN useradd app -d /app -m
RUN chown -R app /app
USER app

ADD Gemfile Gemfile.lock /app/
RUN bundle install --path vendor/bundle

ADD --chown=app . /app/

CMD ["./entrypoint.sh"]

FROM base as rspec
CMD /app/bin/ci-rspec

FROM base as production 

RUN RAILS_ENV=production OIDC_ISSUER=localhost OIDC_SIGNING_KEY="Zm9vCg==" SECRET_KEY_BASE=$(bundle exec rails secret) bundle exec rails assets:precompile

