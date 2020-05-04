# frozen_string_literal: true

class User < ApplicationRecord
  Devise.add_module(:remote_user_authenticatable, strategy: true, controller: :sessions, model: 'devise/models/remote_user_authenticatable')
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :remote_user_authenticatable, :trackable, :database_authenticatable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

  def populate_ldap_attributes
    is_admin = Array.wrap(ldap_results[:groups]).include?(ldap_admin_umg)
    update!(is_admin: is_admin)
  end

  def ldap_results
    @ldap_results ||= PsuLdapService.find(access_id)
  end

  def groups
    ldap_results[:groups]
  end

  def surname
    ldap_results[:surname]
  end

  def given_name
    ldap_results[:given_name]
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

    def ldap_admin_umg
      ENV['LDAP_ADMIN_UMG'] || 'umg/up.ul.dsrd.sudoers'
    end
end
