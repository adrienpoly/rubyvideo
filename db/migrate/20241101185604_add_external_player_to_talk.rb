class AddExternalPlayerToTalk < ActiveRecord::Migration[8.0]
  def change
    add_column :talks, :external_player, :boolean, null: false, default: false
    add_column :talks, :external_player_url, :string, null: false, default: ""
  end
end
