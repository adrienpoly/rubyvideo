class AddNameToEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :name, :string, default: "", null: false
    add_index :events, :name
  end
end
