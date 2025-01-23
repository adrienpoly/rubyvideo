class CreateSocialProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :social_profiles do |t|
      t.string :value
      t.integer :provider
      t.belongs_to :sociable, polymorphic: true
      t.timestamps
    end
  end
end
