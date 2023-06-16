class AddIndexSlugToSpeaker < ActiveRecord::Migration[7.1]
  def change
    add_index :speakers, :slug, unique: true
  end
end
