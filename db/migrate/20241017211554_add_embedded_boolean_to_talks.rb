# frozen_string_literal: true

class AddEmbeddedBooleanToTalks < ActiveRecord::Migration[7.2]
  def change
    add_column :talks, :embedded, :boolean, default: false
  end
end
