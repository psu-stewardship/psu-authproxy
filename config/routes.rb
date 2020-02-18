# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # devise_for :machines
  use_doorkeeper_openid_connect
  use_doorkeeper
  devise_for :users, path: 'users'
  # devise_for :machines, path: 'users'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # TODO: authenticate admin here
  namespace :api do
    namespace :v1 do
      authenticate :user do
        constraints AdminUser do
          resources :application
        end
      end
    end
  end

  root to: redirect('/oauth/applications')

  mount OkComputer::Engine, at: '/health'

  get 'user', to: 'user#show'
end
