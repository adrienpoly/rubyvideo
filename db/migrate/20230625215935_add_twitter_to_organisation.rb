class AddTwitterToOrganisation < ActiveRecord::Migration[7.1]
  def change
    add_column :organisations, :twitter, :string, default: "", null: false
    add_column :organisations, :language, :string, default: "", null: false
  end
end
