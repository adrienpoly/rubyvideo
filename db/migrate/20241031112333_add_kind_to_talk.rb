class AddKindToTalk < ActiveRecord::Migration[8.0]
  def change
    add_column :talks, :kind, :string, null: false, default: "talk"
  end
end
