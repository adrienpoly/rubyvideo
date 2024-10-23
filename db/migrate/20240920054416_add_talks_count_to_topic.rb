class AddTalksCountToTopic < ActiveRecord::Migration[7.2]
  def up
    add_column :topics, :talks_count, :integer

    TalkTopic.find_each do |talk_topic|
      talk_topic.reset_topic_counter_cache
    end
  end

  def down
    remove_column :topics, :talks_count
  end
end
