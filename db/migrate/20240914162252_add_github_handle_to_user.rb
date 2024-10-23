class AddGitHubHandleToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :github_handle, :string

    add_index :users, :github_handle, unique: true, where: "github_handle IS NOT NULL"
    ConnectedAccount.all.each do |connected_account|
      connected_account.user.update(github_handle: connected_account.username)
    end
  end
end
