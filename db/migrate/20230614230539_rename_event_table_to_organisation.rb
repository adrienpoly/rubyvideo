class RenameEventTableToOrganisation < ActiveRecord::Migration[7.1]
  def change
    rename_table :events, :organisations
  end
end
