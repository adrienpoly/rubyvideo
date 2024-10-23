class AddTalksCountToWatchList < ActiveRecord::Migration[7.2]
  def up
    add_column :watch_lists, :talks_count, :integer, default: 0

    WatchListTalk.find_each do |watch_list_talk|
      watch_list_talk.reset_watch_list_counter_cache
    end
  end

  def down
    remove_column :watch_lists, :talks_count
  end
end
