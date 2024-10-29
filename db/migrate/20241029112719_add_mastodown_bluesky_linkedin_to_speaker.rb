class AddMastodownBlueskyLinkedinToSpeaker < ActiveRecord::Migration[8.0]
  def change
    add_column :speakers, :mastodon, :string
    add_column :speakers, :bsky, :string
    add_column :speakers, :linkedin, :string
  end
end
