class AddNameToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
  end
end
