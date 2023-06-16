class AddEventReferencesToTalk < ActiveRecord::Migration[7.1]
  def change
    add_reference :talks, :event, foreign_key: true
  end
end
