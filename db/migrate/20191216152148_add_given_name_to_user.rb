class AddGivenNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :given_name, :string
  end
end
