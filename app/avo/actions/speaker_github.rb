class Avo::Actions::SpeakerGithub < Avo::BaseAction
  self.name = "Try to enhance Speaker profile with Github"

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      Speaker::EnhanceProfileJob.perform_later(speaker: record, sleep: 2) # sleep 2 seconds to avoid rate limit
    end
  end
end
