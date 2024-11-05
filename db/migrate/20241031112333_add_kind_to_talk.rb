class AddKindToTalk < ActiveRecord::Migration[8.0]
  def change
    add_column :talks, :kind, :string, null: true, default: "standard"
  end
end
