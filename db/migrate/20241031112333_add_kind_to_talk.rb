class AddKindToTalk < ActiveRecord::Migration[8.0]
  def change
    add_column :talks, :kind, :string, null: true

    Talk.update_all kind: :standard

    change_column_null :talks, :kind, false
  end
end
