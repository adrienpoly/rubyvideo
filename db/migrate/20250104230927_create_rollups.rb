class CreateRollups < ActiveRecord::Migration[8.0]
  def change
    create_table :rollups do |t|
      t.string :name, null: false
      t.string :interval, null: false
      t.datetime :time, null: false
      t.float :value
    end
    add_index :rollups, [:name, :interval, :time], unique: true
  end
end
