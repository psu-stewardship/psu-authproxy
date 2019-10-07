class AddAccessIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :access_id, :string
  end
end
