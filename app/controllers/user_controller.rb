# frozen_string_literal: true

class UserController < ApplicationController
  before_action :doorkeeper_authorize!

  # TODO what happens when user doesn't exist?
  # TODO what happens when LDAP is down?
  def show
    user = User.find(doorkeeper_token.resource_owner_id)
    render json: user, status: :ok
  end
end
