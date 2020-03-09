class DropLdapColumnsFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column(:users, :first_name, :string)
    remove_column(:users, :last_name, :string)
    remove_column(:users, :primary_affiliation, :string)
  end
end
