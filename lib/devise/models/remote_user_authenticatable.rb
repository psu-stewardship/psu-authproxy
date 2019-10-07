
require 'devise/strategies/remote_user_authenticatable.rb'

module Devise
  module Models
    module RemoteUserAuthenticatable
      extend ActiveSupport::Concern

      def after_database_authentication; end
    end
  end
end
