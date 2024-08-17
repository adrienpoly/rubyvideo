class AddCanonicalReferenceToTopic < ActiveRecord::Migration[7.2]
  def change
    add_reference :topics, :canonical, foreign_key: {to_table: :topics}
  end
end
