class AddEmbeddingToTalks < ActiveRecord::Migration[7.1]
  def change
    add_column :talks, :embedding, :jsonb, null: true
  end
end
