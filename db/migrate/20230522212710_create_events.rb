class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :name, default: "", null: false
      t.text :description, default: "", null: false
      t.string :website, default: "", null: false
      t.integer :kind, default: 0, null: false
      t.integer :frequency, default: 0, null: false

      t.timestamps
    end

    add_index :events, :name
    add_index :events, :kind
    add_index :events, :frequency
  end
end
