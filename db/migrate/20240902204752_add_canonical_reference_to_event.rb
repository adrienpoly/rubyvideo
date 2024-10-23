class AddCanonicalReferenceToEvent < ActiveRecord::Migration[7.2]
  def change
    add_reference :events, :canonical, foreign_key: {to_table: :events}
  end
end
