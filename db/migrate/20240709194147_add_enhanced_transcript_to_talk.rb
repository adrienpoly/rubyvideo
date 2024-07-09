class AddEnhancedTranscriptToTalk < ActiveRecord::Migration[7.1]
  def change
    add_column :talks, :enhanced_transcript, :text, default: "", null: false
  end
end
