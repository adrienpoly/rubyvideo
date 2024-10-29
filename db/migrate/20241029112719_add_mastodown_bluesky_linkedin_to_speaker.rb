class AddMastodownBlueskyLinkedinToSpeaker < ActiveRecord::Migration[8.0]
  def change
    add_column :speakers, :mastodon, :string, default: "", null: false
    add_column :speakers, :bsky, :string, default: "", null: false
    add_column :speakers, :linkedin, :string, default: "", null: false
  end
end
