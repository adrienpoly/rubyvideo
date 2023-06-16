class AddSlugToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :slug, :string, default: "", null: false
    add_index :events, :slug
  end
end
