class AddTranscriptToTalk < ActiveRecord::Migration[7.1]
  def change
    add_column :talks, :transcript, :text, default: "", null: false
  end
end
