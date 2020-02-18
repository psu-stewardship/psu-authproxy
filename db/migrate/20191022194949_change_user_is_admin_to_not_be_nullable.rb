# frozen_string_literal: true

class ChangeUserIsAdminToNotBeNullable < ActiveRecord::Migration[5.2]
  def change
    connection.execute('UPDATE users SET is_admin = FALSE WHERE is_admin IS NULL')
    change_column(:users, :is_admin, :boolean, null: false, default: false)
  end
end
