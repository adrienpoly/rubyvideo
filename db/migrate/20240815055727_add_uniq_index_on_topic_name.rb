class AddUniqIndexOnTopicName < ActiveRecord::Migration[7.2]
  def change
    add_index :topics, :name, unique: true
  end
end
