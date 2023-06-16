class CreateSpeakers < ActiveRecord::Migration[7.1]
  def change
    create_table :speakers do |t|
      t.string :name, default: "", null: false
      t.string :twitter, default: "", null: false
      t.string :github, default: "", null: false
      t.text :bio, default: "", null: false
      t.string :website, default: "", null: false
      t.string :slug, default: "", null: false

      t.timestamps
    end
    add_index :speakers, :name
  end
end
