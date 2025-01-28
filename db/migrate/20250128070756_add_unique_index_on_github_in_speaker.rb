class AddUniqueIndexOnGitHubInSpeaker < ActiveRecord::Migration[8.0]
  def change
    # remove all github handles for speakers having a canonical speaker
    Speaker.where.not(canonical_id: nil).update_all(github: "")
    puts Speaker.group(:github).having("count(*) > 1").pluck(:github)
    add_index :speakers, :github, unique: true
  end
end
