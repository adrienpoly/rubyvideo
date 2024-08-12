class AddUniqIndexSpeakerTalk < ActiveRecord::Migration[7.1]
  def change
    remove_index :speaker_talks, [:speaker_id, :talk_id], if_exists: true
    add_index :speaker_talks, [:speaker_id, :talk_id], unique: true
  end
end
