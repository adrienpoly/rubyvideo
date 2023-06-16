class CreateNewEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.date :date
      t.string :city
      t.string :country_code
      t.references :organisation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
