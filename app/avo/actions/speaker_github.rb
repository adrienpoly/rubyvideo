class Avo::Actions::SpeakerGithub < Avo::BaseAction
  self.name = "Try to enhance Speaker profile with Github"

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      Speaker::EnhanceProfileJob.perform_later(record)
    end
  end
end
