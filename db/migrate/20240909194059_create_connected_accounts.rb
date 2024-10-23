class CreateConnectedAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :connected_accounts do |t|
      t.string :uid
      t.string :provider
      t.string :username
      t.references :user, null: false, foreign_key: true
      t.string :access_token
      t.datetime :expires_at

      t.timestamps
    end

    add_index :connected_accounts, [:provider, :uid], unique: true
    add_index :connected_accounts, [:provider, :username], unique: true
  end
end
