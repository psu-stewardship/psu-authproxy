# frozen_string_literal: true

require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class RemoteUserAuthenticatable < Authenticatable
      def authenticate!
        access_id = remote_user(request.headers)
        Rails.logger.info "Devise Access ID ******* #{access_id}"
        # TODO: fix this
        if access_id.present? && (access_id != '(null)')
          Rails.logger.info "Access ID Present. #{access_id.length}"
          a = User.find_by(access_id: access_id)
          if a.nil?
            obj = User.create(access_id: access_id, email: "#{access_id}@psu.edu")
            obj.populate_ldap_attributes
          else
            obj = a
            obj.populate_ldap_attributes
          end
          success!(obj)
        else
          fail!
        end
      end

      def valid?
        this_remote_user = remote_user(request.headers)
        return true unless this_remote_user.nil?

        false
      end

      def remote_user(headers)
        headers.fetch('REMOTE_USER', nil) || headers.fetch('HTTP_REMOTE_USER', nil)
      end

    end
  end
end

Warden::Strategies.add(:remote_user_authenticatable, Devise::Strategies::RemoteUserAuthenticatable)
