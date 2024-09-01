class AddTalksCountToEvent < ActiveRecord::Migration[7.2]
  def up
    add_column :events, :talks_count, :integer, default: 0, null: false

    Event.all.each do |event|
      event.update_columns(talks_count: event.talks.count)
    end
  end

  def down
    remove_column :events, :talks_count
  end
end
