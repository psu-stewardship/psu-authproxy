FROM psul/ruby-2.6.5-node-12:20200624 as base

WORKDIR /app

ENV TZ=America/New_York

RUN gem install bundler:2.0.2

RUN useradd app -d /app -m
RUN chown -R app /app
USER app

ADD Gemfile Gemfile.lock /app/
ADD --chown=app vendor /app/vendor
RUN bundle install --path vendor/bundle

ADD --chown=app . /app/

CMD ["./entrypoint.sh"]

FROM base as rspec
CMD /app/bin/ci-rspec

FROM base as production 

RUN RAILS_ENV=production OIDC_ISSUER=localhost OIDC_SIGNING_KEY="Zm9vCg==" SECRET_KEY_BASE=$(bundle exec rails secret) bundle exec rails assets:precompile

CMD ["./entrypoint.sh"]

