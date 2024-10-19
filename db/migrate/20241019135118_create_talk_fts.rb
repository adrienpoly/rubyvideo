class CreateTalkFts < ActiveRecord::Migration[7.2]
  def change
    create_virtual_table :talk_fts, :fts5, ["title", "speaker_names", "summary"]
  end
end
