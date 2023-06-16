class CreateSuggestions < ActiveRecord::Migration[7.1]
  def change
    create_table :suggestions do |t|
      t.text :content
      t.integer :status, default: 0, null: false
      t.references :suggestable, polymorphic: true, null: false

      t.timestamps
    end

    # add_index :suggestions, [:suggestable_id, :suggestable_type], unique: true
    add_index :suggestions, :status
  end
end
