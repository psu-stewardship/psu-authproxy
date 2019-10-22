# frozen_string_literal: true

class UserController < ApplicationController
  before_action :doorkeeper_authorize!
  respond_to :json

  def show
    respond_with current_resource_owner
  end

  def current_resource_owner
    return {} unless doorkeeper_token

    # TODO move this into a class? Or maybe just a .json view?
    # TODO what happens when user doesn't exist?
    # TODO what happens when LDAP is down?
    # TODO keep the Hash#merge below, or be more explicit about which individual
    #      keys we are returning in the response?
    user = User.find(doorkeeper_token.resource_owner_id)
    ldap_response = PsuLdapService.find(user.access_id)

    {
      id: user.id,
      email: user.email,
    }.merge(ldap_response)
  end
end
