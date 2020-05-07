# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'net/ldap'

class PsuLdapService
  class << self
    def find(access_id)
      return LdapUser.new if access_id.nil?

      record = find_user_record(access_id)
      LdapUser.new(record)
    end

    private

      def find_user_record(access_id)
        results = ldap_connection.search(base: ldap_base, filter: "uid=#{access_id}")
        Rails.logger.info("LDAP responded with #{ldap_connection.get_operation_result.message}")
        results[0]
      end

      def ldap_connection
        @ldap_connection ||= Net::LDAP.new(host: ldap_host, bind: true)
      end

      def ldap_host
        ENV.fetch('LDAP_HOST', 'dirapps.aset.psu.edu')
      end

      def ldap_base
        ENV.fetch('LDAP_BASE', 'dc=psu,dc=edu')
      end
  end
end
