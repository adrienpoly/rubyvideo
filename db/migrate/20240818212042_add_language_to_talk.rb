class AddLanguageToTalk < ActiveRecord::Migration[7.2]
  def change
    add_column :talks, :language, :string, null: false, default: "en"
  end
end
