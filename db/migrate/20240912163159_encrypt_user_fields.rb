class EncryptUserFields < ActiveRecord::Migration[7.2]
  def up
    User.all.each do |user|
      user.encrypt
    end
  end

  def down
    User.all.each do |user|
      user.decrypt
    end
  end
end
