

if [ ${APP_ROLE:-app} == "sidekiq" ]; then
    echo "starting sidekiq"
    bundle exec sidekiq
else
    echo "starting rails"
    rails db:create
    rails db:migrate
    rails s -b '0.0.0.0'
fi