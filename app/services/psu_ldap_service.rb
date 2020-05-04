# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'net/ldap'

class PsuLdapService
  class << self
    def find(access_id)
      filter = Net::LDAP::Filter.construct("uid=#{access_id}")
      ldap_record = PsuDir::LdapUser.get_users(filter, ['uid', 'displayname', 'sn', 'givenname', 'edupersonprimaryaffiliation', 'psadminarea'])
      groups = PsuDir::LdapUser.get_groups(access_id)

      return {} if ldap_record.blank?

      {
        surname: ldap_record[0][:sn][0],
        given_name: ldap_record[0][:givenname][0],
        last_name: ldap_record[0][:sn][0],
        first_name: ldap_record[0][:givenname][0],
        primary_affiliation: ldap_record[0][:edupersonprimaryaffiliation][0],
        groups: groups,
        access_id: ldap_record[0][:uid][0],
        admin_area: ldap_record[0][:psadminarea][0]
      }

    end
  end
end
