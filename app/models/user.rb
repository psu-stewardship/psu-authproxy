# frozen_string_literal: true

class User < ApplicationRecord
  Devise.add_module(:remote_user_authenticatable, strategy: true, controller: :sessions, model: 'devise/models/remote_user_authenticatable')
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :remote_user_authenticatable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

  def populate_ldap_attributes
    results = PsuLdapService.find(access_id)
    update_attributes(results)
  end

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  private
end
