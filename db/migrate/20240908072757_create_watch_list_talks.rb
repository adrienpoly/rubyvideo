class CreateWatchListTalks < ActiveRecord::Migration[7.0]
  def change
    create_table :watch_list_talks do |t|
      t.references :watch_list, null: false, foreign_key: true
      t.references :talk, null: false, foreign_key: true

      t.timestamps
    end

    add_index :watch_list_talks, [:watch_list_id, :talk_id], unique: true
  end
end
