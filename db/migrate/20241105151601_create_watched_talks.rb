class CreateWatchedTalks < ActiveRecord::Migration[8.0]
  def change
    create_table :watched_talks do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :talk, null: false, foreign_key: true

      t.timestamps

      t.index [:talk_id, :user_id], unique: true
    end
  end
end
