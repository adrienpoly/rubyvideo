class RecreateTalkTopicIndexes < ActiveRecord::Migration[8.0]
  def change
    remove_index :talk_topics, name: "index_talk_topics_on_talk_id_and_topic_id", if_exists: true
    add_index :talk_topics, :talk_id, name: "index_talk_topics_on_talk_id"
    add_index :talk_topics, :topic_id, name: "index_talk_topics_on_topic_id"
    add_index :talk_topics, ["topic_id", "talk_id"], name: "index_talk_topics_on_topic_id_and_talk_id", unique: true
  end
end
