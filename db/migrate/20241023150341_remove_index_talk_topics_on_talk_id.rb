class RemoveIndexTalkTopicsOnTalkId < ActiveRecord::Migration[8.0]
  def change
    remove_index :talk_topics, :talk_id, name: "index_talk_topics_on_talk_id"
    remove_index :talk_topics, :topic_id, name: "index_talk_topics_on_topic_id"
  end
end
