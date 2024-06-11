class AddPrimaryKeyToSpeakerTalks < ActiveRecord::Migration[7.1]
  def change
    # if primary key does not exist, add it
    if !ActiveRecord::Base.connection.column_exists?(:speaker_talks, :id)
      add_column :speaker_talks, :id, :primary_key
    end
  end
end
