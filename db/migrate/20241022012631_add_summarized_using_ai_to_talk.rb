class AddSummarizedUsingAiToTalk < ActiveRecord::Migration[8.0]
  def change
    add_column :talks, :summarized_using_ai, :boolean, default: true, null: false
  end
end
