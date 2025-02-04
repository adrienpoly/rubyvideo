class AddUniqueIndexOnGitHubInSpeaker < ActiveRecord::Migration[8.0]
  def change
    # remove duplicate with no talks
    Speaker.group(:github).having("count(*) > 1").pluck(:github).each do |github|
      Speaker.where(github: github, talks_count: 0).update_all(github: "")
    end

    # fix one by one
    Speaker.find_by(name: "Andrew").assign_canonical_speaker!(canonical_speaker: Speaker.find_by(name: "Andrew Nesbitt"))
    puts Speaker.group(:github).having("count(*) > 1").pluck(:github)
    # TODO
    # CoralineAda
    # JEG2
    # egiurleo
    # eileencodes
    # gus4no
    # hasumikin
    # headius
    # hogelog
    # hsbt
    # jonatas
    # kou
    # mrzasa
    # okuramasafumi
    # olivierlacan
    # wndxlori
    add_index :speakers, :github, unique: true, where: "github IS NOT NULL AND github != ''"
  end
end
