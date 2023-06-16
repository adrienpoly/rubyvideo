class AddDateToTalk < ActiveRecord::Migration[7.1]
  def change
    add_column :talks, :date, :date
    add_index :talks, :date
  end
end
