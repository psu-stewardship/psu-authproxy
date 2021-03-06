# frozen_string_literal: true

class AdminUser
  def self.matches?(request)
    current_user = request.env['warden'].user
    return false if current_user.blank?

    current_user.is_admin?
  end
end
