class AddStatusToTopic < ActiveRecord::Migration[7.2]
  def change
    add_column :topics, :status, :string, null: false, default: "pending"
    add_index :topics, :status

    Topic.published.update_all(status: "approved")
  end
end
