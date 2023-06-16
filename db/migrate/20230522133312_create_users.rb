class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: {unique: true}
      t.string :password_digest, null: false
      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""

      t.boolean :verified, null: false, default: false
      t.boolean :admin, null: false, default: false

      t.timestamps
    end
  end
end
