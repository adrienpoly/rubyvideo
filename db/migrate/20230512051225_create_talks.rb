class CreateTalks < ActiveRecord::Migration[7.1]
  def change
    create_table :talks do |t|
      t.string :title, default: "", null: false
      t.text :description, default: "", null: false
      t.string :slug, default: "", null: false
      t.string :video_id, default: "", null: false
      t.string :video_provider, default: "", null: false
      t.string :thumbnail_sm, default: "", null: false
      t.string :thumbnail_md, default: "", null: false
      t.string :thumbnail_lg, default: "", null: false
      t.integer :year

      t.timestamps
    end

    add_index :talks, :title
    add_index :talks, :slug
  end
end
