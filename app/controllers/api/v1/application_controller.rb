# frozen_string_literal: true

class Api::V1::ApplicationController < ApplicationController
  def exists?
    Doorkeeper::Application.exists?(name: params[:name])
  end

  def index
    render json: Doorkeeper::Application.all
  end

  def create
    name = params[:name]
    # TODO find a way to pass a list
    redirect_uri = params[:redirect_uri]
    scopes = params.fetch(:scopes, [])
    confidential = params.fetch(:confidential, true)

    msg = Hash.new
    msg[:status] = 200

    if exists?
      # TODO technically we could create many applications with the same name,
      # I just don't know if we want to
      msg[:status] = 409
      msg[:message] = "Client #{params[:name]} Exists. Not recreating"
    else
      begin
        application = Doorkeeper::Application.create!(
          name: name,
          redirect_uri: redirect_uri,
          scopes: scopes,
          confidential: confidential
        )
        msg[:status] = 201
        msg[:message] = application
      rescue ActiveRecord::RecordInvalid => e
        msg[:status] = 500
        msg[:message] = e
      end
    end
    render json: msg[:message], status: msg[:status]
  end
end
