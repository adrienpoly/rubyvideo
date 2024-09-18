class AddSuggestorToSuggestions < ActiveRecord::Migration[7.2]
  def change
    add_reference :suggestions, :suggested_by, foreign_key: {to_table: :users}
  end
end
