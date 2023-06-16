class CreateJoinTableSpeakersTalks < ActiveRecord::Migration[7.1]
  def change
    create_join_table :speakers, :talks, table_name: "speaker_talks" do |t|
      t.index [:speaker_id, :talk_id]

      t.timestamps
    end
  end
end
