# frozen_string_literal: true

class UserController < ApplicationController
  before_action :doorkeeper_authorize!
  respond_to :json

  def show
    respond_with current_resource_owner
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
