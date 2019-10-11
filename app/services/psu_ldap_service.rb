# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'net/ldap'

class PsuLdapService
  class << self
    def find(access_id)
      record = find_user_record(access_id)
      map_record_to_attributes(record)
    end

    private

    def ldap_connection
      return @ldap if @ldap

      @ldap = Net::LDAP.new
      @ldap.host = ldap_host
      @ldap.bind
      @ldap
    end

    def find_user_record(access_id)
      filter = "uid=#{access_id}"
      base = ldap_base
      results = ldap_connection.search(base: base, filter: filter)
      results[0]
    end

    def map_record_to_attributes(ldap_record)
      return nil if ldap_record.blank?

      admin_umg = ldap_admin_umg
      attributes = {
        last_name: ldap_record[:sn][0],
        first_name: ldap_record[:givenname][0],
        primary_affiliation: ldap_record[:edupersonprimaryaffiliation][0],
        is_admin: ldap_record[:psmemberof].include?(admin_umg)
      }
    end

    def ldap_host
      ENV['LDAP_HOST'] || 'dirapps.aset.psu.edu'
    end

    def ldap_base
      ENV['LDAP_BASE'] || 'dc=psu,dc=edu'
    end

    def ldap_admin_umg
      ENV['LDAP_ADMIN_UMG'] || 'cn=umg/up.ul.dsrd.sudoers,dc=psu,dc=edu'
    end
  end
end
