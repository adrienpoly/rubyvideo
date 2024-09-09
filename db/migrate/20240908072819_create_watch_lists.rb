class CreateWatchLists < ActiveRecord::Migration[7.0]
  def change
    create_table :watch_lists do |t|
      t.references :user, null: false
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
