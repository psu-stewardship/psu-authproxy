require "net/ldap"

class LdapController < ApplicationController
  def initialize
    @ldap = Net::LDAP.new
    @ldap.host = Rails.configuration.ldap_server
    @ldap.bind
    @attributes = Hash.new
  end

  def find(access_id)
    attributes = Hash.new
    filter = "uid=#{access_id}"
    base = Rails.configuration.ldap_base
    results = @ldap.search(base: base, filter: filter)
    results[0]
  end

  def ldap_attributes(access_id)
    # TODO parameterize a lot of the LDAP stuff
    admin_umg = Rails.configuration.admin_umg
    result = find(access_id)
    @attributes[:last_name] = result[:sn][0]
    @attributes[:first_name] = result[:givenname][0]
    @attributes[:primary_affiliation] = result[:edupersonprimaryaffiliation][0]
    if result[:psmemberof].include? admin_umg
      @attributes[:is_admin] = true
    end
    @attributes
  end
end
