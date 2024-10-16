class EncryptConnectedAccountField < ActiveRecord::Migration[7.2]
  def up
    ConnectedAccount.all.each do |connected_account|
      connected_account.encrypt
    end
  end

  def down
    ConnectedAccount.all.each do |connected_account|
      connected_account.decrypt
    end
  end
end
