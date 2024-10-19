class CreateTalkFts < ActiveRecord::Migration[7.2]
  def up
    create_virtual_table :talk_fts, :fts5, ["title", "speaker_names", "summary"]

    Talk.all.in_batches.each(&:update_fts_record_later_bulk)
  end

  def down
    drop_virtual_table :talk_fts, :fts5, ["title", "speaker_names", "summary"]
  end
end
