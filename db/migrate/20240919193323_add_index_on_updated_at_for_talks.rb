class AddIndexOnUpdatedAtForTalks < ActiveRecord::Migration[7.2]
  def change
    add_index :talks, :updated_at
  end
end
