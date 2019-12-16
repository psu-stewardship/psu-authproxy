class AddGroupsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :groups, :string, array: true, default: []
  end
end
