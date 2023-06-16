class FixForeignConstrain < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        remove_foreign_key :talks, :organisations
        add_foreign_key :talks, :events
      end

      dir.down do
        remove_foreign_key :talks, :events
        add_foreign_key :talks, :organisations, column: "event_id"
      end
    end
  end
end
