# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 5.2.4'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'coffee-rails', '~> 4.2'
gem 'ddtrace'
gem 'devise', '~> 4.7'
gem 'doorkeeper', '~> 5.2'
gem 'doorkeeper-openid_connect', '~> 1.7'
gem 'jbuilder', '~> 2.5'
gem 'net-ldap', '~> 0.16.1'
gem 'okcomputer', '~> 1.17'
gem 'pg', '~> 1.1'
gem 'puma', '~> 3.12'
gem 'rswag', '~> 2.2'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot', '~> 5.1'
  gem 'factory_bot_rails', '~> 5.1'
  gem 'figaro'
  gem 'pry', '~> 0.12.2'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'niftany'
  gem 'rubocop', '= 0.79.0' # because Niftany isn't compatible with 0.80 yet
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'rspec-rails', '~> 4.0'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.18.2', group: :test
  gem 'webdrivers'
end
