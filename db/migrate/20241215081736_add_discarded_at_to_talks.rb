class AddDiscardedAtToTalks < ActiveRecord::Migration[8.0]
  def change
    add_column :talks, :discarded_at, :datetime
    add_index :talks, :discarded_at
  end
end
