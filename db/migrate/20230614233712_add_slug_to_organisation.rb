class AddSlugToOrganisation < ActiveRecord::Migration[7.1]
  def change
    add_column :organisations, :slug, :string, default: "", null: false
    add_index :organisations, :slug
  end
end
