class AddAffiliationToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :primary_affiliation, :string
  end
end
