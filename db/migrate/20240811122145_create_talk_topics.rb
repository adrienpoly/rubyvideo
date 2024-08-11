class CreateTalkTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :talk_topics do |t|
      t.references :talk, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
