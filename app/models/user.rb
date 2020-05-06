# frozen_string_literal: true

class User < ApplicationRecord
  DEFAULT_ADMIN_UMG = 'cn=umg/up.ul.dsrd.sudoers,dc=psu,dc=edu'

  # Defines a :remote_user_authenticatable module that we can use for authentication
  # Others available are: :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  Devise.add_module(
    :remote_user_authenticatable,
    strategy: true,
    controller: :sessions,
    model: 'devise/models/remote_user_authenticatable'
  )

  # Enables our custom :remote_user_authenticatable module
  # Other options available are: :registerable, :recoverable, :rememberable, :validatable
  devise :remote_user_authenticatable, :trackable, :database_authenticatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  delegate *LdapUser.attributes, to: :ldap_user

  def populate_ldap_attributes
    update!(is_admin: groups.include?(ldap_admin_umg))
  end

  # @note Adds the ldap attributes into the json representation. Note that calling :to_json implicity calls :as_json.
  def as_json(options = {})
    super(options.merge(methods: LdapUser.attributes))
  end

  private

    def ldap_admin_umg
      ENV.fetch('LDAP_ADMIN_UMG', DEFAULT_ADMIN_UMG)
    end

    def ldap_user
      @ldap_user ||= PsuLdapService.find(access_id)
    end
end
