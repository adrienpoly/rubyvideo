class AddPronounsToSpeaker < ActiveRecord::Migration[8.0]
  def change
    add_column :speakers, :pronouns_type, :string, default: "not_specified", null: false
    add_column :speakers, :pronouns, :string, default: "", null: false
  end
end
