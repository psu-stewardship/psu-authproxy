FROM ruby:2.6.3
WORKDIR /app

### Envconsul
RUN curl -Lo /tmp/envconsul.zip https://releases.hashicorp.com/envconsul/0.9.0/envconsul_0.9.0_linux_amd64.zip && \
    unzip /tmp/envconsul.zip -d /bin && \
    rm /tmp/envconsul.zip

## NodeJS
ENV NODE_VERSION 12.9.1
RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

RUN npm install -g yarn

RUN gem install bundler

RUN useradd app -d /app -m
RUN chown -R app /app
USER app

ADD Gemfile Gemfile.lock /app/
RUN bundle install --deployment

ENV TZ=America/New_York

ADD --chown=app . /app/

RUN RAILS_ENV=production SECRET_KEY_BASE=$(bundle exec rails secret) bundle exec rails assets:precompile

CMD ["./entrypoint.sh"]
