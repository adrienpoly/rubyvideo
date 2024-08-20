class CreateTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :topics do |t|
      t.string :name, index: {unique: true}
      t.text :description
      t.boolean :published, default: false
      t.string :slug, null: false

      t.timestamps
    end
  end
end
