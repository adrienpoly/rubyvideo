class AddSpeakerdeckToSpeaker < ActiveRecord::Migration[8.0]
  def change
    add_column :speakers, :speakerdeck, :string, default: "", null: false
  end
end
