class AddUniqIndexOnTalkTopic < ActiveRecord::Migration[7.2]
  def change
    add_index :talk_topics, [:talk_id, :topic_id], unique: true
  end
end
