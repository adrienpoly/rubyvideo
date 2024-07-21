class AddSummaryToTalk < ActiveRecord::Migration[7.2]
  def change
    add_column :talks, :summary, :text, default: "", null: false
  end
end
