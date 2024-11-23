class AddWebsiteToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :website, :string, default: "", null: true
  end
end
