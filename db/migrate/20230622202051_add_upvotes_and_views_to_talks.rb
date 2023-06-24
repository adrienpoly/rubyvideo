class AddUpvotesAndViewsToTalks < ActiveRecord::Migration[7.1]
  def change
    add_column :talks, :like_count, :integer
    add_column :talks, :view_count, :integer
  end
end
