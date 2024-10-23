class RenameTranscriptInTalk < ActiveRecord::Migration[7.1]
  def change
    rename_column :talks, :transcript, :raw_transcript
  end
end
