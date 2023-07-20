class AddPrimaryKeyToSpeakerTalks < ActiveRecord::Migration[7.1]
  def change
    add_column :speaker_talks, :id, :primary_key
  end
end
