# frozen_string_literal: true

class LdapUser
  def self.attributes
    %i(
      groups
      surname
      last_name
      given_name
      first_name
      primary_affiliation
      uid
      admin_area
    )
  end

  # @param [Net::LDAP::Entry, Hash] ldap_entry
  def initialize(ldap_entry = nil)
    @ldap_entry = ldap_entry || Net::LDAP::Entry.new
  end

  def groups
    @ldap_entry[:psmemberof].map do |group|
      group.force_encoding('UTF-8').to_s
    end
  end

  def surname
    @ldap_entry[:sn].first
  end
  alias_method :last_name, :surname

  def given_name
    @ldap_entry[:givenname].first
  end
  alias_method :first_name, :given_name

  def primary_affiliation
    @ldap_entry[:edupersonprimaryaffiliation].first
  end

  def uid
    @ldap_entry[:uid].first
  end

  def admin_area
    @ldap_entry[:psadminarea].first
  end
end
