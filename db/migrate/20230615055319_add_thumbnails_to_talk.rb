class AddThumbnailsToTalk < ActiveRecord::Migration[7.1]
  def change
    add_column :talks, :thumbnail_xs, :string, default: "", null: false
    add_column :talks, :thumbnail_xl, :string, default: "", null: false
  end
end
