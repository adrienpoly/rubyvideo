class AddCanonicalReferenceToSpeaker < ActiveRecord::Migration[7.2]
  def change
    add_reference :speakers, :canonical, foreign_key: {to_table: :speakers}
  end
end
