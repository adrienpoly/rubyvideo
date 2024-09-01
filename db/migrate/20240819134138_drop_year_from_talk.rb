class DropYearFromTalk < ActiveRecord::Migration[7.2]
  def change
    remove_column :talks, :year
  end
end
